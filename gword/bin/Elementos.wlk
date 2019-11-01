import wollok.game.*

object partida{
	var salas = [menu, creditos, nivel]
	var salaActual = 0
	
	method obtenerSala(numeroDeSala){ return salas.get(numeroDeSala) }
	
	method establecerMenuInicial(){
		menu.dibujarElementos()
		menu.mostrarAyuda()
	}
	
	method verificarFin(){
		if(salaActual != 0)
			self.obtenerSala(salaActual).errorSala(2)
		else 
			game.stop()
	}
	
	method llamarAyudante(){ self.obtenerSala(salaActual).mostrarAyuda() }
	
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
		/* Botón Volver */		keyboard.m().onPressDo({ self.establecerSala(0) })
		/* Botón Creditos */	keyboard.c().onPressDo({ self.establecerSala(1) })
		/* Botón Jugar */		keyboard.j().onPressDo({ self.establecerSala(2) })
		/* Botón Salir */		keyboard.s().onPressDo({ self.verificarFin() })
		/* Botón ayudante */	keyboard.a().onPressDo({ self.llamarAyudante() })
	}
}

object menu{
	var elementos = 
	[
		new Boton("Menu/btnJugar.png", game.width()/2.5, 9), 
		new Boton("Menu/btnCreditos.png", game.width()/2.5, 7),
		new Boton("Menu/btnSalir.png", game.width()/2.5, 5),
		new Texto("Menu/txtTitulo.png", 7, 12),
		new Ayudante(1, 1)
	]
	
	method dibujarElementos(){ elementos.forEach({ x => game.addVisualCharacter(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x) }) }
	
	method accionBotonCreditos(){ partida.establecerSala(2) }
	
	method botonJugar(){ return elementos.get(0) }
	
	method llamarAyudante(){ return elementos.get(4) }
	
	method errorSala(numeroError){ self.llamarAyudante().mostrarError(numeroError) }
	
	method mostrarAyuda(){ self.llamarAyudante().ayudaEnMenu() }
}

object creditos{
	var elementos = 
	[
		new Texto("Creditos/txtCreditos.png", 7, 5), 
		new Ayudante(1, 1)
	]
	
	method dibujarElementos(){  elementos.forEach({ x => game.addVisualCharacter(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
	
	method accionBotonVolver(){ partida.establecerSala(0) }
	
	method llamarAyudante(){ return elementos.get(1) }
	
	method errorSala(numeroError){ self.llamarAyudante().mostrarError(numeroError) }
	
	method mostrarAyuda(){ self.llamarAyudante().ayudaEnCreditos() }
}

object nivel{
	var elementos = 
	[
		new Texto("txtConsigna.png", 5, 14),
		new Letra(10, 12),
		new Ayudante(1, 1)
	]
	
	var objetos =
	[
		new Foto("so.png", 7, 8),
		new Foto("so.png",11, 8),
		new Foto("so.png",7, 4),
		new Foto("so.png",11, 4)
	]
	
	var numeroLetraElegida
	var property letraElegida
	var objetoElegido
	
	var letras = ["b", "v"]
	var palabras = 
	[
		[1, 2, 3, 4, 5, 6], 
		[7, 8, 9, 10, 11, 12]
	]
	
	method llamarAyudante(){ return elementos.get(2) }
	
	method errorSala(numeroError){ self.llamarAyudante().mostrarError(numeroError) }
	
	method mostrarAyuda(){ self.llamarAyudante().ayudaEnJuego() }
	
	method dibujarElementos(){
		self.configurarObjetos()
		objetos.forEach({ x => game.addVisualCharacter(x) })
		elementos.forEach({ x => game.addVisualCharacter(x)})
	}
	
	method eliminarElementos(){
		self.establecerPalabras()
		objetos.forEach({ x => game.removeVisual(x) x.restablecerImagen() })
		elementos.forEach({ x => game.removeVisual(x)})
	}
	
	method generarNumeroAleatorio(minimo, maximo){ return (minimo .. maximo).anyOne() }
	
	method seleccionarObjeto(numero){ return objetos.get(numero) }
	
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

class Ayudante{
	var property position
	
	var errores = 
	[
		"No podes ir al Menú.",
		"No podes ir a Creditos.",
		"No podes salir del juego.",
		"Ya estas en la sala."
	]
	
	constructor(x, y){ position = game.at(x, y) }
	
	method image(){ return "ayudante.png" }
	
	method ayudaEnCreditos(){ return game.say(self, "Apreta M para volver al menú.") }
	
	method ayudaEnJuego(){ return game.say(self, "Usa los números para elegir.") }
	
	method ayudaEnMenu(){ 
		game.say(self, "Apreta J para jugar")
		game.say(self, "Apreta C para ver los créditos")
		game.say(self, "Apreta S para salir del juego")
	}
	
	method mostrarError(numeroError){ return game.say(self, errores.get(numeroError)) }

}
