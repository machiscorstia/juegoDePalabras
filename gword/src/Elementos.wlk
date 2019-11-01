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
			self.obtenerSala(salaActual).mostrarError(1)
		else 
			game.stop()
	}
	method establecerSala(numeroDeSala){
		if(numeroDeSala == salaActual)
			self.obtenerSala(salaActual).errorSala(2)
		else if(numeroDeSala == 1 and salaActual == 2){
			nivel.errorSala(0)
		}else{
		self.obtenerSala(salaActual).eliminarElementos()
		salaActual = numeroDeSala
		self.obtenerSala(salaActual).dibujarElementos()
		}
	}

	method establecerAccesoDeTeclado(){
		/* Botón Jugar */		keyboard.j().onPressDo({ self.establecerSala(2) })
		/* Botón Volver */		keyboard.m().onPressDo({ self.establecerSala(0) })
		/* Botón Creditos */	keyboard.c().onPressDo({ self.establecerSala(1) })
		/* Botón Salir */		keyboard.s().onPressDo({ self.verificarFin() })
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
	
	method mostrarAyuda(){ elementos.get(4).ayudaEnMenu() }
}

object creditos{
	var elementos = 
	[
		new Texto("Creditos/txtCreditos.png", 7, 5), 
		new Ayudante(1, 1)
	]
	
	method dibujarElementos(){ 
		elementos.forEach({ x => game.addVisualCharacter(x)})
		game.say(elementos.get(1), "Apreta M para volver al menú!")
	}
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
	
	method accionBotonVolver(){ partida.establecerSala(0) }
	
	method errorSala(numeroError){ elementos.get(1).mostrarError(numeroError) }
	
	method mostrarAyuda(){ elementos.get(1).ayudaEnCreditos() }
}

object nivel{
	var elementos = [
		new Texto("txtConsigna.png", 5, 14),
		new Letra(10, 12),
		new Texto("so.png", 7, 8),
		new Texto("so.png", 11, 8),
		new Texto("so.png", 7, 4),
		new Texto("so.png", 11, 4),
		new Ayudante(1, 1)
	]
	var letras = ["b", "c", "v", "z"]
	
	var letraElegida
	
	method establecerParametros(){
		letraElegida = letras.anyOne()
	}
	
	method errorSala(numeroError){ elementos.get(6).mostrarError(numeroError) }
	
	method letraElegida(){ return letraElegida }
	
	method dibujarElementos(){
		self.establecerParametros()  
		elementos.forEach({ x => game.addVisualCharacter(x)})
	}
	
	method eliminarElementos(){ elementos.forEach({ x => game.removeVisual(x)}) }
}

class Letra{
	var property position
	
	constructor(x, y){ position = game.at(x, y) }

	method image(){ return "Letras/" + nivel.letraElegida() + ".png" }
}

class Foto{
	var property position
	
	var letra = 0
	var rutaImagen
	
	constructor(x, y){ position = game.at(x, y) }
	
	method iamge(){ return rutaImagen }
	
	method establecerLetra(_letra){ letra = _letra}
	
	method establecerFoto(texto){ rutaImagen = texto + ".png" }
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
		"No podes ir a Creditos!",
		"No podes salir del juego!",
		"Ya estas en la sala!"
	]
	constructor(x, y){ position = game.at(x, y) }
	
	method image(){ return "ayudante.png" }
	
	method ayudaEnCreditos(){ return game.say(self, "Apreta M para volver al menu!") }
	
	method ayudaEnMenu(){ return game.say(self, "(1) Jugar, (2) Creditos, (3) Salir") }
	
	method mostrarError(numeroError){ return game.say(self, errores.get(numeroError)) }

}
