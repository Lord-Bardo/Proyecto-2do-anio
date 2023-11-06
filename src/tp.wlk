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
object pantallaFinalArgentina{
	const ruta="campeones.png"
	method position() = game.at(0,0)
	
	method image(){
		return ruta	
}
}
object pantallaFinalFrancia{
	const ruta="fotoGanaFrancia.png"
	method position() = game.at(0,0)
	
	method image(){
		return ruta	
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
		menuInicio.iniciarMenu()
		//menuInicio.empezarTurno()
		}
}
object paleta { 
const property rojo = "FF0000FF"
const property blanco = "FFFFFF"
	}
	
class Atributo{
	var nro 
	const x
	const y
	var imagen =""
	
	method nuevaRuta(img){
		imagen =img
	}
	method position() = game.at(x,y)
	method image()= imagen
	method text() = nro.toString()
	method textColor() = paleta.blanco()
	method valor() = nro
	method modificarValor(i){ //deberia llamarse sumar valor
		nro +=i
	}
	method cambiarValorA(i){
		nro = i
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
	
	
	method asignarImagenVida(){
		vida.nuevaRuta("BarritaVida.png")
	}
	method asignarImagenDefensa(){
		defensa.nuevaRuta("defensa.png")
	}
	method asignarImagenStamina(){
		stamina.nuevaRuta("stamina.png")
	}
	method asignarImagenDanio(){
		danio.nuevaRuta("ataque.png")
	}
	
	method aumentarAtributo(aumento,atributo){
		if(atributo== "defensa"){
			defensa.cambiarValorA(90.min(self.consultarDefensa()+aumento))
		}
		if(atributo =="danio"){
			danio.modificarValor(aumento)
		}
		if(atributo =="vida"){
			vida.modificarValor(aumento)
		}
		if(atributo =="stamina"){
			stamina.modificarValor(aumento)
		}
	}
	
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
	method consultarStamina() = stamina.valor()	
	method consultarDefensa() = defensa.valor()
	
	method atacar(objetivo){
		objetivo.recibeDanio(danio.valor())
	}
	method estaMuerto(){
		return self.consultarVida() ==0
	}
	
	method recibeDanio(dmg){
	
		vida.modificarValor(-dmg* (100- defensa.valor())/100)
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
		if (mazo.size() > 0){ 
		mano.add(mazo.head())
		//mano = mano.filter{i => i != []}	
		mazo.remove(mazo.head())
		mano.last().cambiarX(981)
		game.addVisual(mano.last())
	}
	}
	

   
	method sePuedeJugar(carta){
		return	carta.consultarCosto() <= stamina.valor()
	}
	
	method extra(indice){
		
	}
	
	method juega (enemigo, indice){
		var c = mano.get(indice)
		if (self.sePuedeJugar(c)){
			mazo.add(c)
			c.hacerEfecto(self,enemigo)
			self.extra(indice)
			self.restarStamina(c.consultarCosto())
		
		} else { game.say(c,"No me podes jugar te falta mana")
		}
	
	}
}
/* */
class Messi inherits Personaje{ //este es messi
	
	override method extra (indice){
			var c = mano.get(indice)
			mano.remove(c)
			game.removeVisual(c)
		
		}
		//	mano.add(mazo.head())	
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
	var atributo
	method hacerEfecto(personaje, atacado){
		personaje.aumentarAtributo(aumento,atributo)
	}	
}

class Menu{
	var juegaMessi = true
	var fase = 1
	var enemigoActual = vanGal
	
	
	const balonesDeOro1 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro2 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro3 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro4 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro5 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro6 = new CartaAtaque(costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	
	const daniobasico1 = new CartaAtaque(costo = 1, ruta = "dañobasico.png", x= 441)
	const daniobasico2 = new CartaAtaque(costo = 1, ruta = "dañobasico.png", x= 441)
	const daniobasico3 = new CartaAtaque(costo = 1, ruta = "dañobasico.png", x= 441)
	const daniobasico4 = new CartaAtaque(costo = 1, ruta = "dañobasico.png", x= 441)
	
	const botines1 = new CartaAumento(costo = 1, ruta = "Botinesf50.png", x= 221, aumento= 5, atributo ="danio")
	const botines2 = new CartaAumento(costo = 1, ruta = "Botinesf50.png", x= 221, aumento= 5, atributo ="danio")
	
	const hormonas1 = new CartaAumento(costo = 2, ruta = "Hormonas.png", x= 221, aumento= 10,atributo= "danio")
	const hormonas2 = new CartaAumento(costo = 2, ruta = "Hormonas.png", x= 221, aumento= 10,atributo= "danio")
	const hormonas3 = new CartaAumento(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10,atributo= "danio")
	const hormonas4 = new CartaAumento(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10,atributo= "danio")
	
	const dibu1 = new CartaAumento(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10,atributo= "defensa")
	const dibu2 = new CartaAumento(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10,atributo= "defensa")
	const dibu3 = new CartaAumento(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10,atributo= "defensa")
	const dibu4 = new CartaAumento(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10,atributo= "defensa")
	
	const milaGod1 = new CartaAumento(costo = 1, ruta = "MilaGod.png", x= 38,aumento= 50,atributo= "vida")
	const milaGod2 = new CartaAumento(costo = 1, ruta = "MilaGod.png", x= 38,aumento= 50,atributo= "vida")
	
	const siestita1 = new CartaAumento(costo =1 , ruta ="Siestita.png",x=38, aumento =3, atributo ="stamina")
	
	
	
	
	const listaMessi = [daniobasico1, hormonas1, balonesDeOro1, botines1, balonesDeOro2, milaGod1, dibu1, balonesDeOro3, siestita1, daniobasico2, milaGod2, dibu2,daniobasico3, hormonas2, daniobasico4]
	const listaMbapee = [balonesDeOro4,hormonas3, balonesDeOro5,balonesDeOro6,hormonas4]
	const listaMo = [balonesDeOro4,hormonas3, balonesDeOro5,balonesDeOro6,hormonas4]
	const listaV = [balonesDeOro4,hormonas3, balonesDeOro5,balonesDeOro6,hormonas4]
	
	const vidaP = new Atributo(nro = 300, x= 700,y = 577)
	const staminaP= new Atributo(nro =2,x= 900, y=600)
	const defensaP = new Atributo(nro = 50, x= 900, y= 500)
	const danioP = new Atributo(nro = 20, x=900 , y= 400)	
	
	const vidaMo = new Atributo(nro = 150, x= 700,y = 577)
	const staminaMo= new Atributo(nro =2,x= 900, y=600)
	const defensaMo = new Atributo(nro = 20, x= 900, y= 500)
	const danioMo = new Atributo(nro = 20, x=900 , y= 400)	
	
	const vidaV = new Atributo(nro = 100, x= 700,y = 577) 
	const staminaV= new Atributo(nro =2,x= 900, y=600)
	const defensaV = new Atributo(nro = 50, x= 900, y= 500)
	const danioV = new Atributo(nro = 10, x=900 , y= 400)
		
	
	const vidaMessi = new Atributo(nro = 100, x= 325,y = 577)
	const staminaMessi= new Atributo(nro = 2, x= 270, y=600)
	const defensaMessi = new Atributo(nro = 10, x= 270, y= 500)
	const danioMessi = new Atributo(nro = 10, x=270 , y= 400) 
	
	
	const messi = new Messi(vida=vidaMessi, danio = danioMessi, defensa= defensaMessi, ruta = "Messi.png",x=360, y=423, listaCartas= listaMessi,stamina=staminaMessi)
	const mbapee = new Personaje(vida = vidaP, danio = danioP, defensa = defensaP, ruta="Mbappe.png",x=740,y=420, listaCartas = listaMbapee,stamina=staminaP)
	const modrik = new Personaje (vida = vidaMo, danio = danioMo, defensa = defensaMo, ruta ="modrik.png",x=740,y=420,listaCartas= listaMo,stamina=staminaMo )
	const vanGal =  new Personaje (vida = vidaV, danio = danioV, defensa = defensaV, ruta ="vanGal.png",x=740,y=420,listaCartas= listaV,stamina=staminaV )
	
	method iniciarMenu(){
		self.reasignarEnemigoActual()
		
		game.addVisual(messi)
		game.addVisual(enemigoActual)
		
		self.asignacionImagenes(messi)
		self.asignacionImagenes(enemigoActual)
		
		self.inicializarMano()
		self.iniciarManoP()
		
		self.mostrarPersonaje(messi)
		game.addVisual(cursor)
		self.mostrarPersonaje(enemigoActual)
		self.movimiento()
		
	}
	method asignacionImagenes(personaje){
		personaje.asignarImagenVida()
		personaje.asignarImagenDefensa()
		personaje.asignarImagenStamina()
		personaje.asignarImagenDanio()
	}
	method mostrarPersonaje(personaje){
		game.addVisual(personaje.devolverStamina())
		game.addVisual(personaje.devolverVida())
		game.addVisual(personaje.devolverDefensa())
		game.addVisual(personaje.devolverDanio())
	}
	
	method inicializarMano(){
		var i=0
		messi.asignarMazo()
		messi.asignarMano()
		messi.mano().forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }
		messi.mano().forEach { carta => game.addVisual(carta)}
}				
	method iniciarManoP(){
		enemigoActual.asignarMazo()
		enemigoActual.asignarMano()
	}

//Posiciones Cartas: 38 , 273.75 , 509.5 , 745.25, 981 

	
	method movimiento(){
		keyboard.right().onPressDo{cursor.moverDerecha()}
		keyboard.left().onPressDo{cursor.moverIzquierda()}
		keyboard.enter().onPressDo{self.turnoMessi()}
		
	}
	
	
	
	method turnoMessi(){
		if (juegaMessi){
			game.removeVisual(cursor)
			juegaMessi=false
			messi.juega(enemigoActual, cursor.obtenerIndice())
			self.modificarPosicionCartas(messi.mano())
			game.schedule(2000, { self.turnoEnemigo() })
			//self.turnoEnemigo()
			self.empezarTurno()
		}
	}
	method turnoEnemigo(){
			enemigoActual.juega(messi,0)	
			game.schedule(2000, {juegaMessi=true;game.addVisual(cursor)})
	}
	method empezarTurno(){
		messi.incrementarStamina()
		enemigoActual.incrementarStamina()
		
		if(messi.estaMuerto()){ //se deberia mostrar algo como gano francia 
			game.clear()
			game.addVisual(pantallaFinalFrancia)
		}
		else {
			if(enemigoActual.estaMuerto()){ // animacion de que muere enemigo y se muestra un "gano Argentina"
				game.clear()
				if(fase ==3){
					game.addVisual(pantallaFinalArgentina)
				}
				else{
					game.schedule(1000,{fase++;self.reasignarEnemigoActual();self.iniciarMenu(); juegaMessi=true})
				}
			
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

	method reasignarEnemigoActual(){
		enemigoActual = self.devolverEnemigoActual()
	}
	
	method devolverEnemigoActual(){
		if(fase ==1){
			return vanGal
		}
		if(fase == 2){
			return modrik
		}
		if(fase ==3){
			return mbapee
		}
		else return mbapee //esto deberia devolver una excepcion
	}
	
	method devolverMessi(){
		return messi
		}

	}