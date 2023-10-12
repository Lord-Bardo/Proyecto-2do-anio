import wollok.game.*

object tpIntegrador {
	method jugar() {
		var menuInicio = new Menu()
		game.cellSize(1)
		game.width(1200)
		game.height(740)
		game.boardGround("fondoCancha.png")
		game.start()
		game.addVisual(menuInicio.devolverMessi())
		game.addVisual(menuInicio.devolverEnemigoActual())
		menuInicio.empezarTurno()
		}
}

class Personaje{
	var vida
	var danio 
	var defensa
	var x
	var y
	var ruta
	
	method position() = game.at(x,y)
	
	method vidaPersonaje(){
		return 0.max(vida)
	}
	method image(){
		return ruta
	}
	method devolverDefensa(){
		return defensa
	}
	method consultarDanio(){
		return danio
	}
	method atacar(objetivo){
		objetivo.recibeDanio(danio)
	}
	method recibeDanio(dmg){
		vida = vida - (dmg * (1 - defensa))
	}
	method aumentarDefensa(aumento){  //el aumento es un nro entre 0 y 1
		defensa = defensa + aumento 
	}
	method juega (enemigo,listaCartas){
		
		listaCartas.forEach({z => z.hacerEfecto(self,enemigo)})
	
	}
}




class Carta{
	var costo
	var x
	const y =3
	var ruta
	
	method image() = ruta
	method position() = game.at(x,y)
}
class CartaAtaque inherits Carta{
	method hacerEfecto(atacante, atacado){
		atacante.atacar(atacado)
	}
}
class CartaAumento inherits Carta{
	var aumento
	method hacerEfecto(personaje, atacado){
		personaje.aumentarDefensa(aumento)
	}	
}


class Menu{
	
	const messi = new Personaje(vida=500, danio = 20, defensa=0.4, ruta = "Messi.png",x=300, y=300)
	const enemigo1 = new Personaje(vida = 30, danio = 40, defensa = 0.2, ruta="Mbappe.png",x=900,y=300)
	
	
	const balonesDeOro = new CartaAtaque(costo = 1 , ruta = "BalonesDeOro.png", x= 10)
	const hormonas = new CartaAumento(costo = 1, ruta = "Hormonas.png", x= 230, aumento= 0.2)
	
	
	
	method empezarTurno (){
	var	listaMessi = [balonesDeOro, hormonas, balonesDeOro]
	var listaEnemigo = [hormonas,hormonas, balonesDeOro]
		
	game.addVisual(balonesDeOro)
	game.addVisual(hormonas)
	
	messi.juega(enemigo1, listaMessi)	
	enemigo1.juega(messi,listaEnemigo)
	
	if	(self.estaMuerto(messi)) {
	// animacion de que muere messi y se muestra un "gano Francia"
	}
	else {
		if (self.estaMuerto(enemigo1)){ 
		// animacion de que muere enemigo y se muestra un "gano Argentina"
		} 
		else {
			self.empezarTurno() 
		} 
	}
	}
	
	method consultarVida(personaje){
	return personaje.vidaPersonaje()
	}
	
	method consultarDefensa(personaje){
	return personaje.devolverDefensa()
	}
		
	method estaMuerto(personaje){
		return (self.consultarVida(personaje) == 0)
	}
	method devolverEnemigoActual(){
		return enemigo1
	}
	method devolverMessi(){
	return messi
	}

}



