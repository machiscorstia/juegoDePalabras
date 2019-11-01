import wollok.game.*


object partida{
	var salas = [menu, creditos]
	var salaActual = 0
	
	method obtenerSala(numeroDeSala){ return salas.get(numeroDeSala) }
	
	method establecerMenuInicial(){
		menu.dibujarElementos()
		menu.mostrarAyuda()
	}
	
	method establecerSala(numeroDeSala){
		self.obtenerSala(salaActual).eliminarElementos()
		salaActual = numeroDeSala
		self.obtenerSala(salaActual).dibujarElementos()
	}

	method establecerAccesoDeTeclado(){
		keyboard.m().onPressDo({ self.establecerSala(0) })
		keyboard.c().onPressDo({ self.establecerSala(1) })
	}
}

object menu{
	var elementos = 
	[
		new Boton("Menu/btnJugar.png", game.width()/2.5, game.height()/2), 
		new Boton("Menu/btnCreditos.png", game.width()/2.5, game.height()/2.5),
		new Boton("Menu/btnSalir.png", game.width()/2.5, game.height()/3.5),
		new Texto("Menu/txtTitulo.png", 7, 11),
		new Ayudante(1, 1)
	]
	
	method dibujarElementos(){ elementos.forEach({ x => game.addVisualCharacter(x)}) }
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x) }) }
	
	method accionBotonCreditos(){ partida.establecerSala(2) }
	
	method mostrarAyuda(){ elementos.get(4).ayudaEnMenu() }
}

object creditos{
	var elementos = 
	[
		new Texto("txtCreditos.png", 5, 5), 
		new Boton("btnVolver.png", 1, 1)
	]
	
	method dibujarElementos(){ 
		elementos.forEach({ x => game.addVisualCharacter(x)})
		game.say(elementos.get(1), "Apreta M para volver al menú!")
	}
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
	
	method accionBotonVolver(){ partida.establecerSala(0) }
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
	
	constructor(x, y){ position = game.at(x, y) }
	
	method image(){ return "ayudante.png" }
	
	method ayudaEnMenu(){ return game.say(self, "(1) Jugar, (2) Creditos, (3) Salir") }
}
