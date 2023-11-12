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
class PantallaFinal{
	const ruta
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
		menuInicio.iniciarMenu()
		game.start()
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
	
	method position() = game.at(x,y)
	method image()
	method text() = nro.toString()
	method textColor() = paleta.blanco()
	method valor() = nro
	method modificarValor(i){ //deberia llamarse sumar valor
		nro +=i
	}
}
/*const vidaP = new Vida(nro= 300, x= 700,y = 577)
	const staminaP= new Stamina(nro =200,x= 900, y=600)
	const defensaP = new Defensa(nro = 50, x= 900, y= 500)
	const danioP = new Danio(nro = 20, x=900 , y= 400)	 */
class Vida inherits Atributo (x=700,y=577){
	
	
	override method image()= "BarritaVida.png"
}

class Danio inherits Atributo(x=900 , y= 400){
	
	
	override method image()= "ataque.png"
}

class Defensa inherits Atributo(x= 900, y= 500){
	
	override method modificarValor(i){ //deberia llamarse sumar valor
		if (90>=nro+i){
			super(i)
			}
		}
	
	override method image()= "defensa.png"
}

class Stamina inherits Atributo(x= 900, y=600){
	
	
	override method image()= "stamina.png"
}

class Personaje{
	const vida 
	const danio 
	const defensa
	const stamina 
	var x= 740
	var y= 420
	var ruta
	var listaCartas 
	var mano = new List()
	var mazo = new List()
	
	
	method mostrarAtributos(){
		game.addVisual(vida)
		game.addVisual(danio)
		game.addVisual(defensa)
		
	}
	
	/*
	 * 	messi.asignarMazo()
		messi.asignarMano()
		messi.mano().forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }
		messi.mano().forEach { carta => game.addVisual(carta)}
	 */
	method asignarCartas(){
		self.asignarMazo()
		self.asignarMano()
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
	
		vida.modificarValor(-dmg* ((100- defensa.valor())/100))
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
			c.hacerEneVeces(self,enemigo)
			self.extra(indice)
			self.restarStamina(c.consultarCosto())
		
		} else { game.say(c,"No me podes jugar te falta mana")
		}
	
	}
}

class Messi inherits Personaje(vida = new Vida(nro = 100, x= 325,y = 577), defensa = new Defensa(nro = 20, x= 270, y= 500),stamina =new Stamina(nro = 2, x= 270, y=600),danio =new Danio(nro = 10, x=270 , y= 400),ruta = "Messi.png",x=360, y=423){ //este es messi

	override method extra (indice){
			var c = mano.get(indice)
			mano.remove(c)
			game.removeVisual(c)
		
		}
	method dondeVoy(indice){
		return 38 + (indice *235.75)
	}
	/*	messi.asignarMazo()
		messi.asignarMano()
		messi.mano().forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }
		messi.mano().forEach { carta => game.addVisual(carta)} */
	override method asignarCartas(){
		var i=0
		super()
		mano.forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }
		mano.forEach { carta => game.addVisual(carta)}
	}
	
	method modificarPosicionCartas(){	
		var i = 0
		mano.forEach{carta => carta.cambiarX(self.dondeVoy(i)); i++ }		
	}
	
}





class Carta{
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
	method hacerEfecto(personaje, atacado)
	method hacerEneVeces(atacante,atacado)
	
	
}
	

class CartaAtaque inherits Carta{
	const multiplicador = 1 
	var i = multiplicador
	override method hacerEfecto(atacante, atacado){
		atacante.atacar(atacado)
	}
	override method hacerEneVeces(atacante,atacado){
        if (i>0){
            i--
            self.hacerEfecto(atacante,atacado)
			self.hacerEneVeces(atacante,atacado)       
        } else i=multiplicador
    }
}

class CartaAumento inherits Carta{
	var aumento
	
	method queAtributoSoy(personaje)
	
	override method hacerEfecto(personaje, atacado){
		self.queAtributoSoy(personaje).modificarValor(aumento)
	}
	override method hacerEneVeces(atacante,atacado){
		self.hacerEfecto(atacante,atacado)
	}	
}

class CartaAumentoDefensa inherits CartaAumento {
	
	override method queAtributoSoy(personaje){
		return personaje.devolverDefensa()
	}
}
class CartaAumentoVida inherits CartaAumento {
	
	override method queAtributoSoy(personaje){
		return personaje.devolverVida()
	}
}
class CartaAumentoDanio inherits CartaAumento {
	
	override method queAtributoSoy(personaje){
		return personaje.devolverDanio()
	}
}
class CartaAumentoStamina inherits CartaAumento {
	
	override method queAtributoSoy(personaje){
		return personaje.devolverStamina()
	}
}


class Menu{
	var juegaMessi = true
	var fase = 0
	var enemigoActual = vanGal
	const ganoArgentina = new PantallaFinal(ruta="campeones.png")
	const ganoFrancia = new PantallaFinal(ruta="fotoGanaFrancia.png")
	const ganoCroacia = new PantallaFinal(ruta="fotoGanaCroacia.png")
	const ganoHolanda = new PantallaFinal(ruta="fotoGanaHolanda.png")
	
	const balonesDeOro1 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro2 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro3 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro4 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro5 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	const balonesDeOro6 = new CartaAtaque(multiplicador = 2, costo = 3 , ruta = "BalonesDeOro.png", x= 441)
	
	const danioBasico1 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico2 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico3 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico4 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico8 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico7 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico5 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)
	const danioBasico6 = new CartaAtaque(costo = 0, ruta = "dañobasico.png", x= 441)

	const botines = new CartaAumentoDanio(costo = 0, ruta = "Botinesf50.png", x= 221, aumento= 5)
	const botines1 = new CartaAumentoDanio(costo = 0, ruta = "Botinesf50.png", x= 221, aumento= 5) 
	const botines2 = new CartaAumentoDanio(costo = 0, ruta = "Botinesf50.png", x= 221, aumento= 5)
	const botines3 = new CartaAumentoDanio(costo = 0, ruta = "Botinesf50.png", x= 221, aumento= 5)
	const hormonas1 = new CartaAumentoDanio(costo = 2, ruta = "Hormonas.png", x= 221, aumento= 10)
	const hormonas2 = new CartaAumentoDanio(costo = 2, ruta = "Hormonas.png", x= 221, aumento= 10)
	const hormonas3 = new CartaAumentoDanio(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10)
	const hormonas4 = new CartaAumentoDanio(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10)
	const hormonas5 = new CartaAumentoDanio(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10)
	const hormonas6 = new CartaAumentoDanio(costo = 2 , ruta = "Hormonas.png", x= 221, aumento= 10)
	const dibu1 = new CartaAumentoDefensa(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10)
	const dibu2 = new CartaAumentoDefensa(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10)
	const dibu3 = new CartaAumentoDefensa(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10)
	const dibu4 = new CartaAumentoDefensa(costo = 2, ruta = "Dibu.png", x= 38, aumento= 10)
	
	const milaGod = new CartaAumentoVida(costo = 1, ruta = "MilaGod.png", x= 38,aumento= 20)
	const milaGod1 = new CartaAumentoVida(costo = 1, ruta = "MilaGod.png", x= 38,aumento= 20)
	const milaGod2 = new CartaAumentoVida(costo = 1, ruta = "MilaGod.png", x= 38,aumento= 20)
	const pilegol = new CartaAumentoVida(costo = 2, ruta = "pilegol.png", x= 38,aumento= 50)
	
	const siestita = new CartaAumentoStamina(costo =2 , ruta ="Siestita.png",x=38, aumento =10)
	
	
	const listaMessi = [danioBasico4, hormonas1, botines, milaGod, botines1, balonesDeOro1, botines2, hormonas4, hormonas5, 
		danioBasico5, balonesDeOro3, milaGod1, dibu1, danioBasico6, pilegol, balonesDeOro4, siestita, botines3, danioBasico1, 
		milaGod2, dibu2,danioBasico2, hormonas6, danioBasico3
	]
	const listaMbapee = [balonesDeOro2,hormonas2, balonesDeOro5,balonesDeOro6,hormonas3]
	const listaMo = [danioBasico8,hormonas2, balonesDeOro5,balonesDeOro6,hormonas3]
	const listaV = [danioBasico7,hormonas2, balonesDeOro5,balonesDeOro6,hormonas3]
	
	
	const messi = new Messi(listaCartas= listaMessi)
	const mbapee = new Personaje(vida = new Vida(nro= 150), danio = new Danio(nro = 20), defensa = new Defensa(nro = 40), ruta="Mbappe.png", listaCartas = listaMbapee,stamina=new Stamina(nro =1000))
	const modrik = new Personaje (vida = new Vida(nro= 130), danio = new Danio(nro = 20)	, defensa = new Defensa(nro = 20), ruta ="modrik.png",listaCartas= listaMo,stamina=new Stamina(nro =1000) )
	const vanGal =  new Personaje (vida =  new Vida(nro= 110), danio = new Danio(nro = 10), defensa = new Defensa(nro = 40), ruta ="vanGal.png",listaCartas= listaV,stamina=new Stamina(nro =1000) )
	
	method iniciarMenu(){
		self.reasignarEnemigoActual()
		
		game.addVisual(messi)
		game.addVisual(enemigoActual)
		
		messi.asignarCartas()
		enemigoActual.asignarCartas()
		
		messi.mostrarAtributos()
		game.addVisual(messi.devolverStamina())
		enemigoActual.mostrarAtributos()
		
		game.addVisual(cursor)
		self.movimiento()
		
	}
	
	
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
			messi.modificarPosicionCartas()
			game.schedule(2000, { self.turnoEnemigo() })
			//self.turnoEnemigo()
			self.empezarTurno()
		}
	}
	
	method turnoEnemigo(){
			enemigoActual.juega(messi,0)
			if(messi.estaMuerto()){ //se deberia mostrar algo como gano francia 
			game.clear()
			game.addVisual(self.devolverPantallaFinal())
		}	else {
			game.schedule(2000, {juegaMessi=true;game.addVisual(cursor)})
	}
	}
	method empezarTurno(){
		messi.incrementarStamina()
		enemigoActual.incrementarStamina()
		
		
			if(enemigoActual.estaMuerto()){ // animacion de que muere enemigo y se muestra un "gano Argentina"
				game.clear()
				if(fase ==2){
					game.addVisual(ganoArgentina)
				}
				else{
					game.schedule(1000,{fase++;self.reasignarEnemigoActual();self.iniciarMenu(); juegaMessi=true})
				}
			
			} 
			else {
			 	if(messi.mano().size()<5){
			 		messi.agregarCarta()				 
				}
			}
		} 
		
	
	
	

	method reasignarEnemigoActual(){
		enemigoActual = self.devolverEnemigoActual()
	}
	
	method devolverPantallaFinal(){
		const pantallas=[ganoHolanda,ganoCroacia,ganoFrancia]
		return pantallas.get(fase)
	}
	method devolverEnemigoActual(){
		const enemigos =[vanGal,modrik,mbapee]
		return enemigos.get(fase)
	}
	
	method devolverMessi(){
		return messi
		}

	}
