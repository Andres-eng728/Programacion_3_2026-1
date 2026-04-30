# restaurante.exs
# Demostración de procesos ligeros en Elixir
# Ejecutar con: elixir restaurante.exs

defmodule Restaurante do
  @menu %{
    pizza:  %{nombre: "Pizza",  tiempo: 2, precio: 12},
    sushi:  %{nombre: "Sushi",  tiempo: 1, precio: 15},
    burger: %{nombre: "Burger", tiempo: 1, precio: 10},
  }

  # ---------- Contador (proceso con estado) ----------

  def iniciar_contador() do
    spawn(fn -> loop_contador(%{pedidos: 0, ganancias: 0, fallos: 0}) end)
  end

  defp loop_contador(estado) do
    receive do
      {:pedido, plato, precio} ->
        IO.puts("  💰 Entregado: #{plato} (+$#{precio})")
        loop_contador(%{estado |
          pedidos:   estado.pedidos + 1,
          ganancias: estado.ganancias + precio
        })

      {:fallo, plato} ->
        IO.puts("  💥 Proceso falló: #{plato}")
        loop_contador(%{estado | fallos: estado.fallos + 1})

      {:reporte, desde} ->
        send(desde, {:ok, estado})
        loop_contador(estado)
    end
  end

  # ---------- Chef (proceso por pedido) ----------

  defp cocinar(plato, contador) do
    %{nombre: nombre, tiempo: tiempo, precio: precio} = @menu[plato]
    IO.puts("  🚀 [PID #{inspect(self())}] Cocinando #{nombre}...")
    Process.sleep(tiempo * 1000)

    if :rand.uniform(10) > 2 do
      send(contador, {:pedido, nombre, precio})
    else
      send(contador, {:fallo, nombre})
    end
  end

  # ---------- API pública ----------

  def ordenar(platos) do
    contador = iniciar_contador()
    IO.puts("\n📋 Pedidos recibidos: #{Enum.join(platos, ", ")}")
    IO.puts("─────────────────────────────────────")

    # Cada pedido es un proceso independiente (no bloquean entre sí)
    pids = Enum.map(platos, fn plato ->
      spawn(fn -> cocinar(plato, contador) end)
    end)

    # Esperamos a que todos los procesos terminen
    Enum.each(pids, fn pid ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, ^pid, _} -> :ok
      end
    end)

    # Solicitamos el reporte final al contador
    send(contador, {:reporte, self()})
    receive do
      {:ok, estado} ->
        IO.puts("─────────────────────────────────────")
        IO.puts("✅ Pedidos completados : #{estado.pedidos}")
        IO.puts("💥 Fallos              : #{estado.fallos}")
        IO.puts("💵 Ganancias totales   : $#{estado.ganancias}")
    end

    Process.exit(contador, :kill)
  end
end

# ── Entrada principal ──────────────────────────────────────────────────────
IO.puts("⚗️  Elixir Restaurant — Procesos Ligeros")

Restaurante.ordenar([:pizza, :sushi, :burger, :pizza, :sushi])
