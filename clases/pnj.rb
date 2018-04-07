

class Atributo
	include Comparable
	attr_reader :inicial, :actual
	def initialize valor
		@inicial = valor
		@actual = @inicial
	end

	def <=>(otro)
		self.actual <=> otro.actual
	end

	def subir cantidad
		@actual + cantidad > @inicial ? @actual = @inicial : @actual += cantidad
	end

	def bajar cantidad
		@actual - cantidad < 1 ? @actual = 0 : @actual -= cantidad
	end

	def to_s
		"#{@actual}/#{@inicial}"
	end
end

class Arma
	attr_reader :daño, :iniciativa

	def initialize daño, iniciativa
		@daño = daño
		@iniciativa = iniciativa
	end
end

class Pnj
	attr_reader :nombre, :edad, 
				:fue, :des, :sal, :per, 
				:tesoros

	def initialize nombre,  atributos = {}, descripción = "", daño, iniciativa, protección 
		@fue = Atributo.new(atributos[:fue])
		@des = Atributo.new(atributos[:des])
		@sal = Atributo.new(atributos[:sal])
		@per = Atributo.new(atributos[:per])
		@arma = Arma.new(daño, iniciativa)
		@nombre = nombre
		@equipo = []
		@descripción = descripción
		@protección = protección
	end

	def atributos_to_s
		"FUE: #{@fue} DES: #{@des} SAL: #{@sal} PER: #{@per}"
	end

	def atributos_to_html
		"<table class='atributos'>
		 <tr><th>FUE</th>    <th>DES</th>     <th>SAL</th>     <th>PER</th></tr>
		 <tr><td>#{@fue}</td> <td>#{@des}</td> <td>#{@sal}</td> <td>#{@per}</td></tr>
		 </table>"
	end

	def desc_to_s
		if @descripción.empty?
			"\n"
		else
			" Descripción\n"\
			"-------------\n"\
			" #{@descripción}\n"
		end
	end


	def tiene_exito? atributo, dificultad
		dados(3, dificultad) < dados(3, atributo.actual)
	end

	def vive?
		@fue.actual > 0 && @sal.actual > 0
	end

	def defensa
		# añadir escudo
		@des.actual
	end

	def impacta? objetivo
		tiene_exito? @des, objetivo.defensa
	end 

	def iniciativa arma=elegir_arma
		dados(3,6) + @des.actual / 3 + arma.iniciativa
	end

	def elegir_arma
		@arma
	end

	def ataca arma=elegir_arma, objetivo
		if impacta? objetivo
			mod = [(@fue.actual / 3), 1].max
			dados(3, arma.daño) + mod
		else
			0
		end
	end

	def sufre daño
		if daño > 0
			daño -= @protección
			case daño
			when (-100..1)
				@sal.bajar 1
			when (2..6)
				@sal.bajar daño/2
				@fue.bajar daño/2
			else
				@sal.bajar daño/2
				@fue.bajar daño/3
				if dados(1,2) == 1
					@des.bajar daño/3
				else
					@per.bajar daño/3
				end
			end
		end
	end

	def cura curacion
		if curacion < 2 
			curacion = 2
		end

		@fue.subir curacion / 2
		@sal.subir curacion / 2
		@des.subir curacion / 3
		@per.subir curacion / 3				
	end


	private

	def dados(tiradas=1,caras=6)
		unless tiradas < 1 || caras < 1
			(1..caras).to_a.sample + dados(tiradas-1, caras)
		else
			0
		end
	end

end