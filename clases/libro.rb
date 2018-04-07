
class Sección
	attr_reader :título, :cabecera, :contenido, :salidas
	def initialize(título, cabecera, contenido, salidas=[])
		@título = título
		@cabecera = cabecera
		@contenido = contenido
		@salidas = salidas
	end

end

class Libro
	attr_reader :secciones
	
	def initialize 

		@secciones = 
		{
			inicio: Sección.new(
				"Inicio",
				"El emperador secreto",
				"
				<h2>
					Las reglas
				</h2>

				<p>
					Esto es un libro-juego interactivo. Es un poco
					narración, un poco juego de rol y un poco aventura
					de texto.
				</p>
				<p>
			    	Funciona de	la siguiente manera. Lees una sección y
			    	escribes qué quieres que haga tu personaje. El ordenador
			    	que hace de máster, o de narrador o de director de juego,
			    	o lo que prefieras, te responderá diciendo qué pasa a
			    	continuación.
				</p>

				<h3>Algunas órdenes</h3>
				
				<p>
					El software que he diseñado solo entiende algunos de los
					verbos del español. Los suficientes para el juego y no 
					demasiados para que no te líes. Son los siguientes:
				</p>
				<ol>
					<li>ayuda: (y) muestra esta lista de verbos</li>
					<li>narra: (n) da más detalles de la sección.</li>
					<li>recoge (r) <em>objeto</em>: recoges ese objeto y lo guardas</li>
					<li>asir   (a) <em>objeto</em>: agarras el objeto con la mano, preparándolo
					para su uso.</li>
					<li>ponerme <em>ropa</em>: (p) sirve para ponerte ropa o armadura</li>
					<li>opción <em>número</em>: (o) elige una de las opciones de la sección.
				    Una vez elegida, la narración continúa en otra sección, así que no te
				    olvides de recoger anteslos objetos que desees o realizar otras 
				    acciones</li>
				    <li>hablar <em>personaje</em>: (h) sirve para hablar con algún personaje.</li>
				</ol> 
				<h3>
				Opciones
				</h3>
				<ol>
				<li>¿Quieres conocer a tu personaje?</li>
				<li>¿O prefieres pasar directamente a la aventura?</li>
				</ol>

				",
				[:personaje, :introducción]
				),

				personaje: Sección.new(
				"Personaje",
				"El emperador secreto",
				"
				<h2>
					Pip, tu personaje
				</h2>

				<p>
					Tienes catorce años. Te llamas Pip que, 
					&mdash;entre otras cosas&mdas;, significa
					<em>Puntito</em>. Es un nombre de esclavo. 
					De tu familia no saben nada y, de momento,
			    	prefieres no pensar mucho en ella.
			    	Hasta aquí lo malo.
				</p>

				<h3> 
					Tu biografía
				</h3>
				<p>
			    	Sí, eres esclavo y todo eso, pero no un
			    	esclavo cualquiera. Verás, has crecido en 
			    	palacio desde que te compraron a los tres
			    	años. Y tuviste la fortuna de que la cayeras
			    	bien a Su Excelencia Dever de Joe, el
			    	Segundo Ministro del Gabinete Imperial. Él
			    	te ha protegido, instruído y enseñado lo básico
			    	de la ciencia médica.
				</p>

				<p>
					Tu trabajo se circunscribe a la enfermería de 
					palacio. Lo que muchas veces significa que te
					despierten en medio de la noche. ¡Y que no sea 
					un príncipe borracho!
				</p>
				
				<h3>
				Opciones
				</h3>
				<ol>
				<li>Pasa a la aventura</li>
				</ol>
				
				",
				[:introducción]
				)


			


		}
		@sección_actual = @secciones[:inicio]
	end

	def nueva_sección  opción
		i = opción.to_i - 1
		@sección_actual = @secciones[@sección_actual.salidas[i]]
	end

	def sección_actual 
		@sección_actual
	end

	def en_salidas? opción
		i = opción.to_i - 1
		@sección_actual.salidas.length > i 
	end

end