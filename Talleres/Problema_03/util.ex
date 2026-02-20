defmodule Util do
  def mostrar_mensaje(mensaje) do
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

def ingresar(mensaje, :entero) do
try do
mensaje
|> ingresar(:texto)
|> String.to_integer()
rescue
ArgumentError ->
"Error, se espera que ingrese un número entero\n"
|> mostrar_error()
mensaje
|> ingresar(:entero)
end
end

def mostrar_error(mensaje) do
IO.puts(:standard_error, mensaje)
end

end
