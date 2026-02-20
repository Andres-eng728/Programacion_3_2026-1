defmodule Util do
  def mostrar(mensaje) do
    mensaje
    |> IO.puts()
  end


def mostrar_mensaje_java(mensaje) do
  System.cmd("java", ["-cp",".","Mensaje", mensaje])
end

def ingresar(mensaje, :texto) do
  mensaje
  |> IO.gets()
  |> String.trim()
end
end
