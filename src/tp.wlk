import wollok.game.*


object cursor { 
	var y = 11
	var x = 34
	var indice = 0
	method moverDerecha(){
		if (x+235.75 > 977.15) {
			x=34
			indice=0
		} else 
			{ 
			x= x+235.75 
			indice++	
			}
		}	
	method moverIzquierda(){
		if (x-235.75 < 34){
			x=977.15
			indice=4
		} else 
			{ 
			x= x-235.75
			indice--
			}
	}
	
	method image() = "Cursor.png"
	method position()= game.at(x,y)
	method obtenerIndice(){
		return indice
	}
}
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
		menuInicio.iniciarMenu()
		menuInicio.movimiento()
		menuInicio.empezarTurno(cursor)
		}
}

class Stamina {
	var nro = 2
	const x 
	const y 
	
	method position() = game.at(x,y)
	method image()= "stamina.png"
	method text() = nro.toString()
	method valor() = nro
	method modificarValor(i){
		nro = nro +i
	}
}

class Personaje{
	var vida
	var danio 
	var defensa
	var x
	var y
	var ruta
	var listaCartas 
	var mano = new List()
	var mazo = new List()
	const stamina 
	
	method asignarMazo(){
		mazo = listaCartas.drop(5)
	}
	method mazo(){
		return mazo
	}
	method asignarMano(){
		mano = listaCartas.take(5)
	}
	method mano(){
		return mano
	}
	method position() = game.at(x,y)
	
	method image(){
		return ruta
	}
	
	method vidaPersonaje(){
		return 0.max(vida)
	}

	method devolverDefensa(){
		return defensa
	}
	method consultarDanio(){
		return danio
	}
	method constultarStamina(){
		return stamina.valor()
	}
	method devolverStamina () = stamina
	
	method incrementarStamina(){
		if (stamina.valor()< 6){
			stamina.modificarValor(+1)	
		}
	}
	method restarStamina(cantidad){
		stamina.modificarValor(-cantidad)
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
	method agregarCarta(){
		mano.add(mazo.head())
		mano = mano.filter{i => i != []}	
	}


	method sePuedeJugar(carta){
		return	carta.consultarCosto() <= stamina.valor()
	}
	
	
	method juega (enemigo, indice){
		var c = mano.get(indice)
		if (self.sePuedeJugar(c)){
			c.hacerEfecto(self,enemigo)
			mano.remove(c)
			game.removeVisual(c)
			self.restarStamina(c.consultarCosto())
		
		} else { game.say(c,"No me podes jugar te falta mana")
		}
		//	mano.add(mazo.head())
		
	}
}


// keyboard.i().onPressDo { game.say(pepita, "hola!") }
// keyboard.rigth().onPressDo {cambiar posicion cursor }
// keyboard.backspace().onPressDo { jugar la carta con posicion cursor}
//object barraVida {
//	const ruta
//	const x
//	const y	
//}


class Carta{ //Las cartas no deberian tener posicion, la posicion la voy dando segun la disponibilidad de la mano, y ya son definidas estas posiciones
	var costo
	var x
	const y =15
	var ruta
	
	method cambiarX(nuevoX){
		x=nuevoX
	}
	
	method consultarCosto() = costo
	
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
	
	const balonesDeOro = new CartaAtaque(costo = 1 , ruta = "Dibu2.png", x= 441)
	const hormonas = new CartaAumento(costo = 1, ruta = "Dibu2.png", x= 221, aumento= 10)
	const dibu = new CartaAumento(costo = 1, ruta = "Dibu2.png", x= 38, aumento= 0.2)
	const hormonas2 = new CartaAumento(costo = 1, ruta = "Dibu2.png", x= 221, aumento= 10)
	const dibu2 = new CartaAumento(costo = 1, ruta = "Siestita.png", x= 38, aumento= 0.2)
	const dibu3 = new CartaAumento(costo = 1, ruta = "Siestita.png", x= 38, aumento= 0.2)
	
	const listaMessi = [balonesDeOro, hormonas, dibu,hormonas2,dibu2,dibu3]
	const listaEnemigo = [hormonas,hormonas, balonesDeOro]
	
	const staminaM= new Stamina(x= 360, y=600)
	const staminaP= new Stamina(x= 800, y=400)
	
	const messi = new Personaje(vida=500, danio = 20, defensa=0.4, ruta = "Messi.png",x=360, y=423, listaCartas= listaMessi,stamina=staminaM)
	const enemigo1 = new Personaje(vida = 30, danio = 40, defensa = 0.2, ruta="Mbappe.png",x=740,y=420, listaCartas = listaEnemigo,stamina=staminaP)
	
	method iniciarMenu(){
		self.inicializarMano(messi)
		game.addVisual(messi.devolverStamina())
	}
	
	method inicializarMano(personaje){
		personaje.asignarMazo()
		personaje.asignarMano()
	}

//Posiciones Cartas: 38 , 273.75 , 509.5 , 745.25, 981 

	
	method movimiento(){
		keyboard.right().onPressDo{cursor.moverDerecha()}
		keyboard.left().onPressDo{cursor.moverIzquierda()}
		keyboard.enter().onPressDo{messi.juega(enemigo1, cursor.obtenerIndice());self.mostrarEnPantalla(messi.mano())}
		
	}
	//method elegirCarta(cursor){   
	//	var r=0
	//	game.addVisual(cursor)
	//	keyboard.right().onPressDo{cursor.moverDerecha()}
	//	keyboard.left().onPressDo{cursor.moverIzquierda()}

	//	keyboard.enter().onPressDo{r= cursor.obtenerIndice()}
		
	//	return r
	//}
	
	
	method empezarTurno(cursor){
		
		self.mostrarEnPantalla(messi.mano())
		
		//game.addVisual(cursor)
		
		//keyboard.left().onPressDo{cursor.moverIzquierda()}

		// messi.juega(enemigo1, self.elegirCarta(cursor))	

		if(self.estaMuerto(messi)){ //se deberia mostrar algo como gano francia 
		game.removeVisual(cursor)
		}
		else {
			if(self.estaMuerto(enemigo1)){ // animacion de que muere enemigo y se muestra un "gano Argentina"
			game.removeVisual(cursor) 
			} 
			else {
			 	if(messi.mano().size()<5){
			 		messi.agregarCarta()				 
				}
				self.mostrarEnPantalla(messi.mano())
				messi.incrementarStamina()
				self.empezarTurno(cursor) //caso en el que no murio nadie
			}
		} 
		
	}
	
	method mostrarEnPantalla(mano){	// SE QUE ES FEO PERO LO HICE ASI DE MOMENTO PARA TANTEAR
		
		var i = 0
		mano.forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }		
	
		//mano.forEach { carta => game.addVisual(carta)}
	}
	
	method dondeVoy(indice){
		if(indice == 0){
            return (38)
        }
        else{
            if(indice == 1){
                return (273.75)
            }
            else{
                if(indice == 2){
                    return (509.5)
                }
                else{
                    if(indice == 3){
                        return (745.25)
                    }
                    else{
                        return (981)
                    }
                }
            }
        }
	}
	// el tablero va de 38 a 1162, se dejan 64,75 pixeles entre cada carta
	//quiero que entre cada carta se dejen 64,75 pixeles
	//la primera posicion para mostrar carta es 38, 17, siendo la 1ra la que varia
	//De todas formas hay siempre como maximo 5 cartas, asi que tal vez podria tener las posiciones definidas
	//Serian: 30 , 213 , 376 , 559, 742 
	//method mostrarListaCartas(listaCartas){
//		var posInicial = game.at(38,17)
	//	listaCartas.forEach({c => self.mostrarCartaPantallaPosicion(c,posInicial)})
	//}
	
	//method mostrarCartaPantallaPosicion(carta, posicion){
	//	game.addVisualIn(carta, posicion)
	//}
	
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



