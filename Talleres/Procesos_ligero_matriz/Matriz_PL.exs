defmodule Matriz do

  def matriz do
    [
      [60,22,41,5],
      [13,33,44,5],
      [89,10,100,99],
      [5,101,6,34]
    ]
  end

  def main do
   matriz= matriz()

   t1=Task.async(fn -> s1(matriz) end)
   t2= Task.async(fn-> s2(matriz) end)

   a = Task.await(t1)
   IO.puts("Resultado a (s1): #{a}")
   b= Task.await(t2)
   IO.puts("Resultado b (s2): #{b}")

   c= s3(a,b)
   s4(c)


  end
def s1(matriz) do
    matriz
    |> Enum.with_index()
    |> Enum.reduce(0, fn {fila, i}, acc ->
      suma_sublista = fila |> Enum.slice(0, i) |> Enum.sum()
      acc + suma_sublista
    end)
  end

  def s2(matriz)do
    elementos = matriz |> List.flatten()
    Enum.sum(elementos) / length(elementos)
  end

  def s3(a,b)do
    a*b
  end

  def s4(c)do
    IO.puts("resultado = #{c}")
  end



end

Matriz.main()
