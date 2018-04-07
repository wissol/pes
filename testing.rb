require "./clases/objetos.rb"
require "./clases/personaje.rb"
require "./clases/master.rb"
require "./clases/pnj.rb"

def suma ary_1, ary_2
	x = [0,0]
	x[0] = ary_1[0]+ary_2[0]
	x[1] = ary_1[1]+ary_2[1]
	x
end



máster = Máster.new

pip = Personaje.new "Pip", 14, atributos = {fue:13, des:13, sal:13, per:16}, descripción = "Un chico interesante", género = :masc

lanza = Objeto.new ({:tipo=>:espada})
lanza2 = Objeto.new ({:tipo=>:espada})
puts pip.carga

puts pip.carga_máxima
puts pip.equipo.inspect

pip.recoge lanza
puts "p", pip.carga

puts pip.carga_máxima

pip.recoge lanza2

100.times {
	pip.recoge lanza2
}

	




