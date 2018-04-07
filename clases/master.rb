
class Máster

	def initialize
	end

	# "<ol>
 #          <li>ayuda: (a) muestra esta lista de verbos</li>
 #          <li>narra: (n) da más detalles de la sección.</li>
 #          <li>guarda (g) <em>objeto</em>: guardas un objeto</li>
 #          <li>usa   (u) <em>objeto</em>: dispones un objeto para su uso. 
 #          Sólo dos objetos pueden usarse a la vez</li>
 #          <li>ponte (p) <em>ropa</em>: viste a tu personaje, ponte una
 #          armadura o calza zapatos o sandalias.</li>
 #          <li><em>número</em>:  elige una de las opciones de la sección.
 #            Una vez elegida, la narración continúa en otra sección, así que no te
 #            olvides de recoger antes los objetos que desees o realizar otras 
 #            acciones</li>
 #            <li>hablar <em>personaje</em>: (h) sirve para hablar con algún personaje.</li>
 #        </ol>"


	# def parse frase_cruda, sección_actual
	# 	frase = frase_cruda.strip.downcase.split
	# 	if frase[0] == "opción" or frase[0] == "o"


	# end

	def no_entiendo
  		"no entiendo"
	end
  

	def ronda_combate personaje_1, personaje_2
		per_1_i = personaje_1.iniciativa
		per_2_i = personaje_2.iniciativa
		if per_1_i > per_2_i
			personaje_2.sufre(personaje_1.ataca personaje_2)
			personaje_1.sufre(personaje_2.ataca personaje_1) if personaje_2.vive?
		elsif per_1_i < per_2_i			
			personaje_1.sufre(personaje_2.ataca personaje_1) 
			personaje_2.sufre(personaje_1.ataca personaje_2) if personaje_1.vive?
		else
			p1_a_sufrir = personaje_2.ataca personaje_1
			p2_a_sufrir = personaje_1.ataca personaje_2
			personaje_1.sufre(p1_a_sufrir)
			personaje_2.sufre(p2_a_sufrir)
		end
	end

	def combate personaje_1, personaje_2
		victoria = 0
		ronda_combate personaje_1, personaje_2
		if personaje_1.vive? && personaje_2.vive?
			combate personaje_1, personaje_2
		else
			victoria = 1 if personaje_1.vive?
			victoria = 2 if personaje_2.vive?
			return victoria
		end
	end

	private

	def dados(tiradas=1,caras=6)
		puts "Tiradas #{tiradas}"
		puts "caras #{caras}"
		unless tiradas < 1 || caras < 1
			(1..caras).to_a.sample + dados(tiradas-1, caras)
		else
			0
		end
	end
end