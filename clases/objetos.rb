

class Objeto
	attr_reader :desc, :carga, :daño, :prot, :ini, :tipo
	
	def initialize entrada
		# atributos :car lo que "pesa", :desc descripción
		# :daño daño que causa, si es arma  :prot lo que protege si es armadura
		# :armadura si armadura, :ropa si ropa
		args   = genera_hash_objeto entrada
		cambia args
	end

	def cambia args
		@desc  = cambiar @desc,  args, :desc	
		@carga = cambiar @carga, args, :carga	
		@daño  = cambiar @daño,  args, :daño	
		@prot  = cambiar @prot,  args, :prot	
		@ini   = cambiar @ini,   args, :ini
		@tipo  = cambiar @tipo,  args, :tipo
	end

	def carga
		@carga
	end

	def to_s
		"#{@desc} #{@carga} #{@daño} #{@ini} #{@prot}"
	end

	def to_sym
		@tipo
	end

	def to_html
	   "<tr>\n"\
	   "  <td>#{@desc.capitalize}</td>\n  <td>#{@daño}</td>\n"\
	   "  <td>#{@prot}</td>\n"\
	   "</tr>"
	end 

	def vestible?
		@tipo == :ropa || @tipo == :armadura || @tipo == :calzado		
	end

	private

	def genera_hash_objeto args
		case args[:tipo] 
		when :espada
			{desc: "espada", carga:2, daño:8, prot:0, ini: 2, :tipo => :arma}
		when :daga
			{desc: "daga",   carga:1, daño:6, prot:0, ini: 1, :tipo => :arma}
		when :escudo
			{desc: "escudo", carga:3, daño:4, prot:0, ini: 1, :tipo => :escudo}
		when :armadura
			{desc: "armadura", carga:3, daño:0, prot:6, ini: 0, :tipo => :armadura}
		when :ropa
			{desc: "ropa", carga:0, daño:0, prot:0, ini: 0, :tipo => :ropa}
		else
			args
		end
	end

	def cambiar valor, args, símbolo
		args.include?(símbolo) ? args[símbolo] : valor
	end

end