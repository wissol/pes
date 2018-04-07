require 'yaml'
require 'sinatra'
require 'erb'
require './clases/objetos'
require './clases/libro'
require './clases/personaje'
require './clases/master'

pip = Personaje.new "Pip", 14, 
		atributos = {fue:9, des:13, sal:13, per:16}, 
		descripción = "Un chico interesante", género = :masc

túnica = Objeto.new({:tipo => :ropa})
túnica.cambia({:desc => "túnica"})

pip.ponte túnica

libro = Libro.new

fragmentos = YAML.load_file "./yml/fragmentos.yml"

máster = Máster.new

class String
  def quita_acentos
    acentos = {"á"=>"a", "é"=>"e", "í"=>"i", "ó"=>"o", "ú"=>"u",
               "Á"=>"A", "É"=>"E", "Í"=>"I", "Ó"=>"O", "Ú"=>"U"}
    self.gsub /[áéíóú]/, acentos
  end 
    
end

class Array
def quita_preposiciones
  preposiciones = "A ante bajo cabe con contra de desde en entre hacia hasta para por según sin sobre tras durante mediante".split
  self.delete_if {|palabra| preposiciones.include? palabra }
end
def quita_artículos
  artículos = "el la las lo un una unos unos".split
  self.delete_if {|palabra| artículos.include? palabra }
end

end

def responder entrada, libro

  # Parámetros
  # 	1. entrada [String] contiene las instrucciones del jugador
  # 	2. libro [Libro] definido en clases/libro.rb
  # 
  # Devuelve:
  # 	1. resultado [String] contiene la respuesta del máster
  # 	2. nueva_sección [Sección] definido en clases/libro.rb
  frase = entrada.strip.downcase.split.quita_preposiciones.quita_artículos
  frase.map! {|palabra| palabra.quita_acentos }
  nueva_sección = libro.sección_actual
  case frase.first
  when "1".."9"
  	if sección_actual.en_salidas? frase.first
	  	resultado = "Elegiste la opción #{frase.first}" 
	    nueva_sección = libro.nueva_sección(frase.first.to_i )
	else
		resultado = "Opción no aparece"
	end
  when "ayuda", "ayudame", "a"
    resultado = "Ayuda"    
  when "guarda", "guardar", "g"
    if frase[1] 
      resutado = "guardar #{frase[1]}"
    else 
      resutado = "guardar qué?"
    end
  when "usa", "usar", "u"
    resultado = "usar"
  else
    resultado = no_entiendo
  end
  return resultado, nueva_sección
end




def display(sección, pj=pip, resultado = "")
	@title = "El emperador secreto | #{sección.título}"
	@header = sección.cabecera
	@content = sección.contenido
	@pj = pj
	@resultado = resultado
	erb :index
end


get "/" do 	 
	display libro.secciones[:inicio], pip, ""
end

post "/" do 
	resultado, nueva_sección = responder params["orden"], libro
	display nueva_sección, pip, resultado
end








