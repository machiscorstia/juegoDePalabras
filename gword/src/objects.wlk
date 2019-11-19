import wollok.game.*

/* Objerto más importante en el juego, controla las salas y el final del juego */
object partida{
	
	/* Colección de las salas */
	var salas = [menu, creditos]
	
	/* Contiene la sala actual expresado en un número */
	var property salaActual = 0
	
	/* Devuelve la sala actual */
	method obtenerSalaActual(){ return salaActual }
	
	/* Devuelve la sala dandole como parámetro su correspondiente número */
	method obtenerSala(numeroDeSala){ return salas.get(numeroDeSala) }
	
	/* Método inicial que establece el menu para empezar el juego, también agrega al selector y ayudante */
	method establecerMenuInicial(){
		menu.dibujarElementos()
		game.addVisual(ayudante)
		game.addVisual(selector)
	}
	
	/* Establece la sala dandole como parámetro el número de la sala */
	
	method establecerSala(numeroDeSala){
		self.obtenerSala(salaActual).eliminarElementos()
		salaActual = numeroDeSala
		self.obtenerSala(salaActual).dibujarElementos()	
	}
	
	/* Establece las acciones del teclado (Wollok Game) */
	method establecerAccesoDeTeclado(){
		//keyboard.m().onPressDo({ self.establecerSala(0) })
		keyboard.s().onPressDo({ selector.moverArriba() })
		keyboard.w().onPressDo({ selector.moverAbajo() })
		keyboard.a().onPressDo({ ayudante.mostrarAyuda(self.obtenerSalaActual()) })
		keyboard.enter().onPressDo({ selector.accionar() })
	}
}

/* Este objeto tiene asignado el rol de brindarle ayuda al jugador */
object ayudante{
	
	/* Posición del objeto constante (Wollok Game) */
	var property position = game.at(1, 1)
	
	/* Colección que contiene textos de los errores que comete el jugador */
	var textosError = 
	[
		"No podes ir al Menú.",
		"No podes ir a Creditos.",
		"No podes salir del juego.",
		"Ya estas en la sala."
	]
	
	var textosAyuda =
	[
		"Usa W y S para mover la flecha",
		"Apretá ENTER para seleccionar",
		"Para volver apreta ENTER",
		"Usa 1, 2, 3 y 4 para mover"
	]
	
	method mostrarAyuda(numeroAyuda){ return game.say(self, textosAyuda.get(numeroAyuda)) }
	
	method mostrarError(numeroError){ return game.say(self, textosError.get(numeroError)) }

	method image(){ return "ayudante.png" }
}

/* Es el segundo objeto más importante ya que controla el movimiento entre las salas
 * Toma la imagen de una simple flecha y su posición cambia dependiendo de la sala actual
 * El metodo acción interactua con el objeto más importante "partida" */
 
object selector{
	
	/* Posición en el tablero del juego (Wollok Game) */
	var property position = game.at(6,5)
	
	/* Posicion en la que se encuentra el selector */
	var posicionActual = 0
	
	/* Sala actual de la partida */
	var salaActual = 0

	/* Colección de las posiciones de cada sala: Menu, Créditos y Nivel */
	var posiciones = 
	[
		[game.at(6, 9), game.at(6, 7), game.at(6, 5)],
		[game.at(100,100), game.at(2, 1)]
	]

	/* Hace que el selector se mueva 1 posición arriba, solamente en el Menu */
	method moverArriba(){
		if(salaActual == 1)
			posicionActual = 0
			
		if(salaActual == 0){
			if(posicionActual == 2)
				posicionActual = 0
			else
				posicionActual++;
		}
		
		self.actualizarPosicion()
		return true
	}
	
	/* Hace que el selector se mueva 1 posición abajo, solamente en el Menu */
	method moverAbajo(){
		if(salaActual == 1){
			posicionActual = 1
			ayudante.mostrarAyuda(2)
		}
		
		if(salaActual == 0){
			if(posicionActual == 0)
				posicionActual = 2
			else 
				posicionActual--
		}	
		self.actualizarPosicion()
	}
	
	
	method accionar(){
		if(salaActual == 0){
			if(posicionActual == 0){
				partida.establecerSala(1)
				salaActual = 1
				posicionActual = 0
			}
		}
		if(salaActual == 1){
			if(posicionActual == 1){
				partida.establecerSala(0)
				salaActual = 0
				posicionActual = 0
			}
		}
		self.actualizarPosicion()
		
	}
	
	method reiniciar(){
		game.removeVisual(self)
		game.addVisual(self)
	}
	
	/* Actualiza la posición del selector */
	method actualizarPosicion(){
		var salaPosicion = posiciones.get(salaActual)
		position = salaPosicion.get(posicionActual)
		console.println(position)
	}
	
	/* Establece su imagen (Wollok Game) */
	method image(){ return "flecha.png" }
}

object menu{
	var elementos = 
	[
		new Boton("Menu/btnJugar.png", game.width()/2.5, 9), 
		new Boton("Menu/btnCreditos.png", game.width()/2.5, 7),
		new Boton("Menu/btnSalir.png", game.width()/2.5, 5),
		new Texto("Menu/txtTitulo.png", 7, 12)
	]
	
	method dibujarElementos(){ elementos.forEach({ x => game.addVisual(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x) }) }
}

object creditos{
	var elementos = [new Texto("Creditos/txtCreditos.png", 6, 5)]
	
	method dibujarElementos(){  elementos.forEach({ x => game.addVisual(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
}

class Texto{
	var property position
	var rutaImagen
	
	constructor(_ruta, _x, _y){
		rutaImagen = _ruta
		position = game.at(_x, _y)
	}
	
	method image(){ return rutaImagen }
}

class Boton{
	var property position
	var rutaImagen
	
	constructor(_rutaImagen, _x, _y){
		rutaImagen = _rutaImagen
		position = game.at(_x, _y)
	}
	
	method image(){ return rutaImagen }
}