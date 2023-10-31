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
object paleta { 
const property rojo = "FF0000FF"
	}
class Atributo{
	var nro 
	const x
	const y
	const imagen
	
	method position() = game.at(x,y)
	method image()= imagen
	method text() = nro.toString()
	method textColor() = paleta.rojo()
	method valor() = nro
	method modificarValor(i){
		nro = nro +i
	}
}

class Personaje{
	const vida 
	const danio 
	const defensa
	const stamina 
	var x
	var y
	var ruta
	var listaCartas 
	var mano = new List()
	var mazo = new List()
	
	
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
	
	method devolverVida()=vida
	method devolverDefensa() =defensa
	method devolverDanio() = danio
	method devolverStamina () = stamina
	
	method consultarVida()= 0.max(vida.valor())
	method consultarDanio()= danio.valor()
	method constultarStamina() = stamina.valor()
	method consultarDefensa() = defensa.valor()
	
	method atacar(objetivo){
		objetivo.recibeDanio(danio.valor())
	}
	method estaMuerto(){
		return self.consultarVida() ==0
	}
	
	method recibeDanio(dmg){
		vida.modificarValor(-danio.valor() * (1- defensa.valor()))
	}
	method aumentarDefensa(aumento){  //el aumento es un nro entre 0 y 1 
		defensa.modificarValor(+aumento)
	}	

	method incrementarStamina(){
		if (stamina.valor()< 6){
			stamina.modificarValor(+1)	
		}
	}
	method restarStamina(cantidad){
		stamina.modificarValor(-cantidad)
	}

	method agregarCarta(){
		mano.add(mazo.head())
		//mano = mano.filter{i => i != []}	
		mazo.remove(mazo.head())
		game.addVisual(mano.last())
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
	const dibu2 = new CartaAumento(costo = 2, ruta = "Siestita.png", x= 38, aumento= 0.2)
	const dibu3 = new CartaAumento(costo = 2, ruta = "Siestita.png", x= 38, aumento= 0.2)
	const dibu4 = new CartaAumento(costo = 1, ruta = "Dibu2.png", x= 221, aumento= 10)
	
	const listaMessi = [balonesDeOro, hormonas, dibu,hormonas2,dibu2,dibu3,dibu4]
	const listaEnemigo = [hormonas,hormonas, balonesDeOro]
	
	const vidaP = new Atributo(nro = 500, x= 900,y = 800, imagen ="BarritaVida.png")
	const staminaP= new Atributo(nro =2,x= 900, y=600, imagen="stamina.png")
	const defensaP = new Atributo(nro = 0.2, x= 900, y= 500, imagen ="stamina.png")
	const danioP = new Atributo(nro = 30, x=900 , y= 400, imagen ="stamina.png")	
		
	
	const vidaMessi = new Atributo(nro = 500, x= 325,y = 577, imagen ="BarritaVida.png")
	const staminaMessi= new Atributo(nro = 2, x= 270, y=600, imagen= "stamina.png")
	const defensaMessi = new Atributo(nro = 0.2, x= 270, y= 500, imagen ="stamina.png")
	const danioMessi = new Atributo(nro = 30, x=270 , y= 400, imagen ="stamina.png") 
	
	
	const messi = new Personaje(vida=vidaMessi, danio = danioMessi, defensa= defensaMessi, ruta = "Messi.png",x=360, y=423, listaCartas= listaMessi,stamina=staminaMessi)
	const enemigo1 = new Personaje(vida = vidaP, danio = danioP, defensa = defensaP, ruta="Mbappe.png",x=740,y=420, listaCartas = listaEnemigo,stamina=staminaP)
	
	method iniciarMenu(){
		self.inicializarMano(messi)
		game.addVisual(messi.devolverStamina())
		game.addVisual(messi.devolverVida())
		game.addVisual(messi.devolverDefensa())
		game.addVisual(messi.devolverDanio())
		game.addVisual(cursor)
		//mismos addVisual para el enemigo
		game.addVisual(enemigo1.devolverStamina())
		game.addVisual(enemigo1.devolverVida())
		game.addVisual(enemigo1.devolverDefensa())
		game.addVisual(enemigo1.devolverDanio())
		
	}
	
	method inicializarMano(personaje){
		var i=0
		
		personaje.asignarMazo()
		personaje.asignarMano()
		personaje.mano().forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }
		personaje.mano().forEach { carta => game.addVisual(carta)}
		
		method agregarCarta(){
		mano.add(mazo.head())
		//mano = mano.filter{i => i != []}	
		mano.last().cambiarX(981)
		game.addVisual(mano.last())
	}
		
	}

//Posiciones Cartas: 38 , 273.75 , 509.5 , 745.25, 981 

	
	method movimiento(){
		keyboard.right().onPressDo{cursor.moverDerecha()}
		keyboard.left().onPressDo{cursor.moverIzquierda()}
		keyboard.enter().onPressDo{messi.juega(enemigo1, cursor.obtenerIndice());self.modificarPosicionCartas(messi.mano());self.empezarTurno(cursor)}
		
	}
	
	method empezarTurno(cursor){
		messi.incrementarStamina()
		if(messi.estaMuerto()){ //se deberia mostrar algo como gano francia 
			game.removeVisual(cursor)
		}
		else {
			if(enemigo1.estaMuerto()){ // animacion de que muere enemigo y se muestra un "gano Argentina"
			game.removeVisual(cursor) 
			} 
			else {
			 	if(messi.mano().size()<5){
			 		messi.agregarCarta()				 
				}
					//self.modificarPosicionCartas(messi.mano())
					 //caso en el que no murio nadie
			}
		} 
		
	}
	
	method modificarPosicionCartas(mano){	
		
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

	
	method devolverEnemigoActual(){
		return enemigo1
		}
	method devolverMessi(){
		return messi
		}

	}


