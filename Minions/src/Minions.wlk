// -----------------------------------------------------------
// VILLANOS
// -----------------------------------------------------------

class Villano {
	const ejercito = #{}
	var ciudad
	
	method nuevoMinion(minion){
		ejercito.add(minion)
		self.alimentar(minion, 5)
		self.otorgarArma(minion, rayoCongelante) // const rayoCongelante = new Arma (potencia = 10)
	}
	
	method otorgarArma(minion, arma){
		minion.agragarArma(arma)
	}
	
	method alimentar(minion, cantidadBananas){
		minion.cambiarBananas(cantidadBananas)
	}
	
	method realizar(maldad){
		maldad.realizarse(self.minionsQueEstenCapacitados(maldad), ciudad)
	}
	
	method minionsQueEstenCapacitados(maldad){
		return ejercito.filter{minion => minion.estaCapacitado(maldad)}
	}	
	
	method minionMasUtil(){
		return ejercito.find {minion, otroMinion => minion.maldadesParticipadas() > otroMinion.maldadesParticipadas()}
	}
	
	method minionsInutiles(){
		return ejercito.filter {minion => minion.maldadesParticipadas() == 0}
	}
}

// -----------------------------------------------------------
// MINIONS
// -----------------------------------------------------------

class Minion{
	var property color = amarillo
	const armas = #{}
	var bananas
	var maldadesParticipadas = 0
	
	method aumentarMaldades(){
		maldadesParticipadas += 1
	}
	
	method esPeligroso(){
		color.esPeligroso(self.cantidadArmas())
	}
	
	method absorberSueroMutante(){
		color.transformar(self)
	}
	
	method nivelConcentracion(){
		return color.calcularNivelConcentracion(self.potenciaArmaMasPotente(), bananas)
	}
	
	method armaMasPotente(){
		return armas.find {arma, otraArma => arma.potencia() > otraArma.potencia()}
	}
	
	method potenciaArmaMasPotente(){
		return self.armaMasPotente().potencia()
	}
	
	method cambiarBananas(cantidad){
		bananas += cantidad
	}
	
	method agregarArma(arma){
		armas.add(arma)
	}
	
	method estaCapacitado(maldad){
		maldad.sirve(self)
	}
	
 	method cantidadArmas(){
 		return armas.size()
 	}
 	
 	method bienAlimentado(){
 		return bananas > 100
 	}
}


// -----------------------------------------------------------
// COLORES
// -----------------------------------------------------------

object amarillo {
	
	method esPeligroso(cantArmas){
		return cantArmas > 2
	}
	
	method transformar(unMinion){
		unMinion.color(violeta)
		unMinion.cambiarBananas(-1)
		unMinion.armas().clear()
	}
	
	method calcularNivelConcentracion(potencia, bananas){ // en vez de pasarle el minion pasarle la potencia y las bananas para no exponer la info del objeto
		return potencia + bananas
	}
	
}

object violeta {
	
	method esPeligroso(cantArmas) = true
	
	method transformar(unMinion){
		unMinion.color(amarillo)
		unMinion.cambiarBananas(-1)
	}
	
	method calcularNivelConcentracion(potencia, bananas){
		return bananas
	}
}

// -----------------------------------------------------------
// ARMAS
// -----------------------------------------------------------

class Arma{
	var property potencia = 0
	
}

const rayoCongelante = new Arma(potencia = 10)

const rayoParaEncoger = new Arma()

// -----------------------------------------------------------
// MALDADES
// -----------------------------------------------------------

object congelar{
	var property nivel = 500
	
	method sirve(minion){
		return minion.armas().contains(rayoCongelante) && minion.nivelConcentracion() > nivel
		
	}
	
	method realizarse(ejercito, ciudad){
		if(ejercito.isEmpty()){
			self.error("no hay ningun minion asignado")
		}
		ciudad.disminuirTemperatura(30)
		ejercito.forEach{minion => minion.cambiarBananas(10) minion.aumentarMaldades()}
		
	}
	
}

object robar{
	var property objetivo = sueroMutante
	
	method sirve(minion){
		return minion.esPeligroso() && objetivo.requerimiento(minion)
	}
	
	method realizarse(ejercito, ciudad){
		if(ejercito.isEmpty()){
			self.error("no hay ningun minion asignado")	
		}
		ciudad.robar(objetivo)
		ejercito.forEach{minion => objetivo.recompensa(minion) minion.aumentarMaldades()}
		
	}
}

// -----------------------------------------------------------
// OBJETIVOS
// -----------------------------------------------------------

class Piramide{
	var altura
	
	method requerimiento(minion){
		return minion.nivelConcentracion() > altura/2
	}
	
	method recompensa(minion){
		minion.cambiarBananas(10)
	}
}

object sueroMutante{
	
	method requerimiento(minion){
		return minion.bienAlimentado() && minion.nivelConcentracion() >= 23
	}
	
	method recompensa(minion){
		minion.absorberSueroMutante()
	}
}

object laLuna {
	
	method requerimiento(minion){
		return minion.armas().contains(rayoParaEncoger)
	}
	
	method recompensa(minion){
		minion.agragarArma(rayoCongelante)
	}
}

// -----------------------------------------------------------
// CIUDADES
// -----------------------------------------------------------

class Ciudad{
	var temperatura
	const objetos = #{}
	
	method disminuirTemperatura(cantidad){
		temperatura -= cantidad
	}
	
	method robar(objeto){
		objetos.remove(objeto)
	}
	
}












