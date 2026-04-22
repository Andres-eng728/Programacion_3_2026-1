defmodule TallerEnum do

  # =========================
  # PUNTO 1
  # =========================

  def procesar(lista) do
    lista
    |> Enum.map(&(String.upcase(&1)))
    |> Enum.filter(fn w -> String.length(w) > 4 end)
    |> Enum.map(fn cadena -> String.reverse(cadena) end)
    |> Enum.sort()
    |> Enum.take(3)
    |> Enum.join(" - ")
  end

  def ejercicio2 do
    numeros = Enum.to_list(1..15)

    numeros
    |> Enum.filter(&(rem(&1, 3) == 0))
    |> Enum.map(&(&1 + 1))
    |> Enum.reduce({0, 0}, fn x, {suma, conteo} ->
      {suma + x, conteo + 1}
    end)
    |> then(fn {suma, conteo} -> suma / conteo end)
  end

  def ejercicio3 do
    personas = [
      %{nombre: "Antonio", edad: 23},
      %{nombre: "Luis", edad: 30},
      %{nombre: "Marta", edad: 19},
      %{nombre: "Pedro", edad: 40},
      %{nombre: "Andrés", edad: 28},
      %{nombre: "Ana", edad: 35}
    ]

    personas
    |> Enum.filter(fn %{nombre: nombre, edad: edad} ->
      edad >= 21 and (nombre |> String.downcase() |> String.starts_with?("a"))
    end)
    |> Enum.map(fn %{nombre: nombre} -> String.upcase(nombre) end)
    |> Enum.sort_by(&String.length(&1))
    |> Enum.join(" | ")
  end

  # =========================
  # DATOS DE VUELOS
  # =========================

  def vuelos do
    [
      %{codigo: "AV201", aerolinea: "Avianca", origen: "BOG", destino: "MDE", duracion: 45, precio: 180_000, pasajeros: 120, disponible: true},
      %{codigo: "LA305", aerolinea: "Latam", origen: "BOG", destino: "CLO", duracion: 55, precio: 210_000, pasajeros: 98, disponible: true},
      %{codigo: "AV410", aerolinea: "Avianca", origen: "MDE", destino: "CTG", duracion: 75, precio: 320_000, pasajeros: 134, disponible: false},
      %{codigo: "VV102", aerolinea: "Viva Air", origen: "BOG", destino: "BAQ", duracion: 90, precio: 145_000, pasajeros: 180, disponible: true},
      %{codigo: "LA512", aerolinea: "Latam", origen: "CLO", destino: "CTG", duracion: 110, precio: 480_000, pasajeros: 76, disponible: false},
      %{codigo: "AV330", aerolinea: "Avianca", origen: "BOG", destino: "CTG", duracion: 135, precio: 520_000, pasajeros: 155, disponible: true},
      %{codigo: "VV215", aerolinea: "Viva Air", origen: "MDE", destino: "BOG", duracion: 50, precio: 130_000, pasajeros: 190, disponible: true},
      %{codigo: "LA620", aerolinea: "Latam", origen: "BOG", destino: "MDE", duracion: 145, precio: 390_000, pasajeros: 112, disponible: true},
      %{codigo: "AV505", aerolinea: "Avianca", origen: "CTG", destino: "BOG", duracion: 120, precio: 440_000, pasajeros: 143, disponible: false},
      %{codigo: "VV340", aerolinea: "Viva Air", origen: "BAQ", destino: "BOG", duracion: 85, precio: 160_000, pasajeros: 175, disponible: true}
    ]
  end

  # =========================
  # PUNTO 2
  # =========================

  def codigos_disponibles(vuelos) do
    vuelos
    |> Enum.filter(& &1.disponible)
    |> Enum.map(& &1.codigo)
    |> Enum.sort()
  end

  def pasajeros_por_aerolinea(vuelos) do
    vuelos
    |> Enum.group_by(& &1.aerolinea)
    |> Enum.map(fn {aerolinea, lista} ->
      total = Enum.reduce(lista, 0, fn v, acc -> acc + v.pasajeros end)
      {aerolinea, total}
    end)
  end

  def formatear_vuelos(vuelos) do
    vuelos
    |> Enum.map(fn v ->
      horas = div(v.duracion, 60)
      minutos = rem(v.duracion, 60)
0
      minutos_str =
        if minutos < 10 do
          "0#{minutos}"
        else
          "#{minutos}"
        end

      "#{v.codigo} — #{v.origen} → #{v.destino}: #{horas}h #{minutos_str}m"
    end)
  end

  def vuelos_con_descuento(vuelos, limite) do
    vuelos
    |> Enum.filter(&(&1.precio < limite))
    |> Enum.map(fn v ->
      precio_final = v.precio * 0.9
      {v.codigo, "#{v.origen}-#{v.destino}", precio_final}
    end)
    |> Enum.sort_by(fn {_, _, precio} -> precio end)
  end

  def aerolineas_completas(vuelos) do
    vuelos
    |> Enum.group_by(& &1.aerolinea)
    |> Enum.filter(fn {_aerolinea, lista} ->
      categorias =
        Enum.map(lista, fn v ->
          cond do
            v.duracion < 60 -> :corto
            v.duracion <= 120 -> :medio
            true -> :largo
          end
        end)

      Enum.member?(categorias, :corto) and
      Enum.member?(categorias, :medio) and
      Enum.member?(categorias, :largo)
    end)
    |> Enum.map(fn {aerolinea, _} -> aerolinea end)
  end

  def rutas_mas_rentables(vuelos) do
    vuelos
    |> Enum.filter(& &1.disponible)
    |> Enum.map(fn v ->
      {"#{v.origen} → #{v.destino}", v.precio * v.pasajeros}
    end)
    |> Enum.group_by(fn {ruta, _} -> ruta end)
    |> Enum.map(fn {ruta, lista} ->
      total = Enum.reduce(lista, 0, fn {_, ingreso}, acc -> acc + ingreso end)
      {ruta, total}
    end)
    |> Enum.sort_by(fn {_, ingreso} -> -ingreso end)
    |> Enum.take(3)
  end

end


# =========================
# PRUEBAS (MAIN)
# =========================

IO.puts("=== PUNTO 1 ===")
IO.puts(TallerEnum.procesar(["Elixir", "es", "un", "lenguaje", "funcional", "muy", "poderoso"]))
IO.puts("Salida ejercicio 2: #{TallerEnum.ejercicio2()}")
IO.puts(TallerEnum.ejercicio3())

IO.puts("\n=== PUNTO 2 ===")

vuelos = TallerEnum.vuelos()

IO.inspect(TallerEnum.codigos_disponibles(vuelos), label: "Códigos disponibles")
IO.inspect(TallerEnum.pasajeros_por_aerolinea(vuelos), label: "Pasajeros por aerolínea")
IO.inspect(TallerEnum.formatear_vuelos(vuelos), label: "Vuelos formateados")
IO.inspect(TallerEnum.vuelos_con_descuento(vuelos, 400_000), label: "Vuelos con descuento")
IO.inspect(TallerEnum.aerolineas_completas(vuelos), label: "Aerolíneas completas")
IO.inspect(TallerEnum.rutas_mas_rentables(vuelos), label: "Top 3 rutas")
