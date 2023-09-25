import wollok.game.*

object tpIntegrador {
	method jugar() {
		
		game.cellSize(1)
		game.width(1200)
		game.height(740)
		game.boardGround("fondoCancha.png")
		game.start()
	}
}

class Personaje{
	var vida
	var danio 
	var defensa
	
	method consultarVida(){
		return vida
	}
	
	method consultarDefensa(){
		return defensa
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
		
		listaCartas.forEach({x => x.hacerEfecto(self,enemigo)})
	
	}
}

class CartaAtaque{
	var costo
	method hacerEfecto(atacante, atacado){
		atacante.atacar(atacado)
	}
}
class CartaDefensa{
	var costo
	var aumento
	method hacerEfecto(personaje, atacado){
		personaje.aumentarDefensa(aumento)
	}	
}


class Menu{
	
	const protagonista = new Personaje(vida=100, danio = 20, defensa=0.4)
	const enemigo1 = new Personaje(vida = 30, danio = 40, defensa = 0.2)
	
	
	const trompada = new CartaAtaque(costo = 1)
	const equiparArmor = new CartaDefensa(costo = 1, aumento = 0.2)
	
	
	method empezarTurno (){
			protagonista.juega(enemigo1,[trompada,equiparArmor])	
		}
		
		
	}
	



