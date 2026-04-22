defmodule Matriz do
  def main do
    matriz = [
      [1, 4, 6],
      [2, 4, 2],
      [9, 8, 7]
    ]

    diagonal = recorrer_diagonal(matriz, 0, [])
    IO.inspect(diagonal)
  end


  def recorrer_diagonal(matriz, i, diagonal) when i <= length(matriz) do
    diagonal
  end


  def recorrer_diagonal(matriz, i, diagonal) do
    valor = matriz |> Enum.at(i) |> Enum.at(i)
    recorrer_diagonal(matriz, i + 1, diagonal ++ [valor])
  end
end

Matriz.main()
