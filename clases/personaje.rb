

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

class Género
	def initialize tipo
		@tipo = tipo
	end

	def to_s
		case @tipo
		when :masc
			"Masculino"
		when :fem
			"Femenino"
		else
			"Otro"
		end
	end
end

class Puño
	def daño 
		3
	end
	def ini
		0
	end
end

class Mano
	attr_reader :objeto
	def initialize
		@objeto = Puño.new
	end

	def is_empty?
		@objeto.is_a?(Puño)
	end

	def asir cosa
		@objeto = cosa
	end

	def soltar
		@objeto = Puño.new
	end

end

class Manos
	def initialize
		@der = Mano.new
		@izq = Mano.new
	end

	def is_empty? 
		@der.is_empty? && @izq.is_empty?
	end

	def arma
		if @der.objeto.ini > @izq.objeto.ini
		   @der.objeto
		elsif @der.objeto.ini < @izq.objeto.ini
		   @izq.objeto
		else 
			if @der.objeto.daño >= @izq.objeto.daño
				@der.objeto
			else
				@izq.objeto
			end
		end
	end

	def asir cosa
		if @der.is_empty?
			@der.asir cosa
			true
		elsif @izq.is_empty?
			@izq.asir cosa
			true
		else
			false
		end
	end
			
end

class Personaje
	attr_reader :nombre, :edad, 
				:fue, :des, :sal, :per, 
				:equipo, :género

	def initialize nombre, edad, atributos = {}, descripción = "", género = :masc
		if atributos.empty?
			if edad < 16
				@fue = Atributo.new(dados(2,4) + 4)
				@des = Atributo.new(dados(2)   + 6)
				@sal = Atributo.new(dados(2,4) + 4)
				@per = Atributo.new(dados(2)   + 6)
			elsif edad > 32
				@fue = Atributo.new(dados(3))
				@des = Atributo.new(dados(3)) 
				@sal = Atributo.new(dados(3)) 
				@per = Atributo.new(dados(3)) 
			else
				@fue = Atributo.new(dados(2) + 6)
				@des = Atributo.new(dados(2) + 6)
				@sal = Atributo.new(dados(2) + 6)
				@per = Atributo.new(dados(2) + 6)
			end
		else
			@fue = Atributo.new(atributos[:fue])
			@des = Atributo.new(atributos[:des])
			@sal = Atributo.new(atributos[:sal])
			@per = Atributo.new(atributos[:per])
		end
		@nombre = nombre
		@edad = edad
		@equipo = []
		@descripción = descripción
		@género = Género.new(género)
		@manos = Manos.new
		@armadura = :ninguna
		@calzado = :descalzo
		@ropa = :desnudo
	end

	def desnudo?
		@ropa == :desnudo
	end

	def descalzo?
		@calzado == :descalzo
	end


	def ponte prenda
		if prenda.vestible?
			case prenda.tipo
			when :armadura
				@armadura = prenda
			when :ropa
				@ropa = prenda
			when :calzado
				@calzado = prenda
			end
		end
		recoge prenda unless @equipo.include? prenda
	end			

	def carga
		if @equipo == [] 
			0 
		else
			total = 0
			@equipo.each {|cosa| total += cosa.carga }
			total
		end
	end

	def carga_máxima
		20 + @fue.actual
	end

	def recoge cosa
		if carga + cosa.carga > carga_máxima
			:demasiado_peso
		else
			@equipo.push cosa
		end
	end

	def asir cosa
		@manos.asir cosa
		cargar cosa unless @equipo.include? cosa
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

	def ropa_to_html
		if @ropa == :desnudo
			rop = "desnudo"
		else
			rop = @ropa.desc
		end
		if @calzado == :descalzo
			zap = "descalzo"
		else
			zap = @calzado.desc
		end
		if @armadura == :ninguna
			arm = "ninguna"
		else
			arm = @armadura.desc
		end
		"<table>
		<tr><th>Ropa</th>  <th>Calzado</th><th>Armadura</th></tr>
		<tr><td>#{rop}</td><td>#{zap}</td> <td>#{arm}</td></tr>
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

	def equipo_to_s
		if @equipo.empty?
			"\n"
		else
			s =  " Equipo\n" 
			s += "--------\n"
			s += "   Desc\t Daño Ini Prot\n"
			@equipo.each {|cosa| s += " * #{cosa.to_s}\n" }
			s
		end
	end
	def to_s
		s  = " Hoja de Personaje\n"
		s += "===================\n\n"
		s += " Edad: #{@edad} Género: #{@género}\n\n"
		s += desc_to_s + "\n"
		s += atributos_to_s + "\n"
		s += equipo_to_s
	end

	def to_html
		s =  "<h2 id='hoja_personaje'>#{@nombre}</h2>\n"
		s += "  <p>Edad: #{@edad} Género: #{@género}</p>\n"
		s += "<h3>Descripción</h3>\n" unless @descripción == ""
		s += "<p>#{@descripción}</p>\n" unless @descripción == ""
		s += "<h3>Atributos</h3>\n"
		s += "  #{atributos_to_html}\n"
		s += "<h3>Equipo Puesto</h3>\n"
		s += "#{ropa_to_html}\n"
		s += "<h3>Lista de Equipo</h3>"
		s += "<table>\n"
		s += "<tr>\n"
      	s += "  <th></th>\n"
      	s += "  <th>Daño</th>\n"
      	s += "  <th>Prot</th>\n"
      	s += "  </tr>\n"
    	e = ""
		@equipo.each {|cosa| e += "#{cosa.to_html}\n"}
		s + e + "\n</table>"		
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

	def iniciativa
		dados(3,6) + @des.actual / 3
	end

	def elegir_arma
		@manos.arma
	end

	def ataca arma=elegir_arma, objetivo
		if impacta? objetivo
			if @fue.actual < 3
				mod = 1
			else
				mod = @fue.actual/3
			end
			dados(3, arma.daño) + mod
		else
			0
		end
	end

	def sufre daño
		if daño > 0
			if @armadura != :ninguna
				protección = @armadura.prot
			else
				protección = 0
			end
			daño -= protección
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