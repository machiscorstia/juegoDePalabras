import wollok.game.*

object partida{
	var salas = [menu, creditos, nivel]
	var salaActual = 0
	
	method obtenerSala(numeroDeSala){ return salas.get(numeroDeSala) }
	
	method obtenerSalaActual(){ return salaActual }
	
	method establecerMenuInicial(){
		menu.dibujarElementos()
		//game.addVisual(puntaje)
		game.addVisual(selector)
		game.addVisual(ayudante)
		ayudante.mostrarAyuda(0) 
	}
	
	method verificarFin(){
		if(salaActual != 0)
			self.obtenerSala(salaActual).errorSala(2)
		else 
			game.stop()
	}
	
	method establecerSala(numeroDeSala){
		if(numeroDeSala == salaActual)
			self.obtenerSala(salaActual).errorSala(3)

		else if(numeroDeSala == 1 and salaActual == 2){
			nivel.errorSala(1)
			
		}else{
			self.obtenerSala(salaActual).eliminarElementos()
			salaActual = numeroDeSala
			self.obtenerSala(salaActual).dibujarElementos()
		}
	}

	method establecerAccesoDeTeclado(){
		/* Botón Volver */		keyboard.m().onPressDo({ self.establecerSala(0) selector.restablecer() })
		/* Botón Salir */		keyboard.s().onPressDo({ selector.moverAbajo() })
		/* Botón Salir */		keyboard.w().onPressDo({ selector.moverArriba() })
		/* Botón ayudante */	keyboard.a().onPressDo({ ayudante.mostrarAyuda(salaActual) })
		keyboard.enter().onPressDo({ selector.accionar() })
		keyboard.num1().onPressDo({ selector.establecerPosicion(0) })
		keyboard.num2().onPressDo({ selector.establecerPosicion(1) })
		keyboard.num3().onPressDo({ selector.establecerPosicion(2) })
		keyboard.num4().onPressDo({ selector.establecerPosicion(3) })
	}
}

object selector{
	var posiciones = 
	[
		[game.at(6, 5), game.at(6, 7), game.at(6, 9)],
		[game.at(7, 8), game.at(11, 8), game.at(7, 4), game.at(11, 4)]
	]
	
	var salaActual = 0
	var posicionActual = 0
	
	var property position = posiciones.get(salaActual).get(0)
	
	method moverArriba(){
		if(posicionActual == 2)
			posicionActual = 0
		else
			posicionActual++;

		self.actualizarPosicion()
	}
	
	method moverAbajo(){
		if(posicionActual == 0)
			posicionActual = 2
		else 
			posicionActual--
		self.actualizarPosicion()
	}
	
	method establecerPosicion(numero){
		posicionActual = numero
		self.actualizarPosicion()
	}
	
	method accionar(){
		if(salaActual == 0){
			if(posicionActual == 2){
				partida.establecerSala(2)
				salaActual = 1
				game.removeVisual(self)
				game.addVisual(self)
				posicionActual = 0
				self.actualizarPosicion()
			}
			if(posicionActual == 1)
				partida.establecerSala(1)
			if(posicionActual == 0 and partida.obtenerSalaActual() == 0)
				game.stop()
		}
		if(salaActual == 1){
			if(posicionActual == 0)
				nivel.verificarObjeto(0)
		}
	}
	
	method restablecer(){ 
		posicionActual = 0
		salaActual = 0
		self.actualizarPosicion()
	}
	
	method actualizarPosicion(){ 
		var salaPosicion = posiciones.get(salaActual)
		position = salaPosicion.get(posicionActual)
		console.println(position)
	}
	
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
	
	method accionBotonCreditos(){ partida.establecerSala(2) }
	
	method botonJugar(){ return elementos.get(0) }
	
	method errorSala(numeroError){ return ayudante.mostrarError(numeroError) }
	
}

object creditos{
	var elementos = [new Texto("Creditos/txtCreditos.png", 7, 5)]
	
	method dibujarElementos(){  elementos.forEach({ x => game.addVisual(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
	
	method accionBotonVolver(){ partida.establecerSala(0) }
	
	method llamarAyudante(){ return elementos.get(1) }
	
	method errorSala(numeroError){ return ayudante.mostrarError(numeroError) }
}

object nivel{
	var elementos = 
	[
		new Texto("txtConsigna.png", 5, 14),
		new Letra(10, 12)
	]
	
	var objetos =
	[
		new Foto("so.png", 7, 8),
		new Foto("so.png",11, 8),
		new Foto("so.png",7, 4),
		new Foto("so.png",11, 4)
	]
	
	var numeroLetraElegida
	var objetoElegido
	var property letraElegida
	
	
	var letras = ["b", "v"]
	var palabras = 
	[
		[1, 2, 3, 4, 5, 6], 
		[7, 8, 9, 10, 11, 12]
	]
	
	method verificarObjeto(numero){
		if(numero == objetoElegido){
			console.println(numero + objetoElegido)
			puntaje.sumar()
			puntaje.mostrar()
			self.reiniciar()
		}else
			self.errorSala(4)
			
	}
	
	method reiniciar(){
		self.eliminarElementos()
		self.dibujarElementos()	
	}
	
	method llamarAyudante(){ return elementos.get(2) }
	
	method errorSala(numeroError){ return ayudante.mostrarError(numeroError) }
	
	method generarNumeroAleatorio(minimo, maximo){ return (minimo .. maximo).anyOne() }
	
	method seleccionarObjeto(numero){ return objetos.get(numero) }
	
	method dibujarElementos(){
		self.configurarObjetos()
		objetos.forEach({ x => game.addVisual(x) })
		elementos.forEach({ x => game.addVisual(x)})
	}
	
	method eliminarElementos(){
		self.establecerPalabras()
		objetos.forEach({ x => game.removeVisual(x) x.restablecerImagen() })
		elementos.forEach({ x => game.removeVisual(x)})
	}
	
	method pedirPalabra(){
		var coleccion = palabras.anyOne()
		var palabra = coleccion.anyOne()
		palabras.forEach({ x => if(x == coleccion) x.remove(palabra)})
		console.println(palabras)
		return palabra
	}
	
	method establecerPalabras(){
		palabras.clear()
		palabras.add([1, 2, 3, 4, 5, 6])
		palabras.add([7, 8, 9, 10, 11, 12])
	}
	
	method configurarObjetos(){
		numeroLetraElegida = self.generarNumeroAleatorio(0, 1)
		letraElegida = letras.get(numeroLetraElegida)
		
		objetoElegido = self.generarNumeroAleatorio(0, 3)
		
		var coleccionElegida = palabras.get(numeroLetraElegida)
		var palabraElegida = coleccionElegida.anyOne()
		
		palabras.remove(coleccionElegida)
		
		self.seleccionarObjeto(objetoElegido).establecerImagen(palabraElegida)
		
		var objetosRestantes = objetos.filter({ x => x.id() != palabraElegida })
		
		objetosRestantes.forEach({ x => x.establecerImagen(self.pedirPalabra())})
	}
}

class Letra{
	var property position
	
	constructor(x, y){ position = game.at(x, y) }

	method image(){ return "Letras/" + nivel.letraElegida() + ".png" }
}

class Foto{
	var property position
	
	var rutaImagen
	var property id = -1
	
	constructor(_ruta, x, y){ 
		rutaImagen = _ruta
		position = game.at(x, y)
	}
	
	method image(){ return rutaImagen }
	
	method restablecerImagen(){ rutaImagen = "so.png" }
	
	method establecerImagen(numero){ 
		rutaImagen = "Fotos/" + numero + ".png" console.println(rutaImagen)
		id = numero
	}
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

object ayudante{
	var property position = game.at(1, 1)
	
	var textos =
	[
		"Usa W y S para mover la flecha..",
		"Apretá ENTER para elegir la opción.",
		"Apretá M para volver al menú.",
		"Usa los numeros para seleccionar."
	]
	
	var errores = 
	[
		"No podes ir al Menú.",
		"No podes ir a Creditos.",
		"No podes salir del juego.",
		"Ya estas en la sala.",
		"Objeto equivocado."
	]
	
	method mostrarAyuda(numero){ 
		if(numero == 0){
			game.say(self, textos.get(0))
			game.say(self, textos.get(1))
		}else
			game.say(self, textos.get(numero+1))
	}
	
	method mostrarError(numeroError){ return game.say(self, errores.get(numeroError)) }
	
	method image(){ return "ayudante.png" }
	
}

object puntaje{
	var puntos = 0
	var property position = game.at(2, 9)

	method restablecer(){ puntos = 0 }
	
	method mostrar(){ game.say(self, "Acertado") }
	
	method sumar(){ puntos ++ }
}
