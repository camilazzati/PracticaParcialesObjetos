// ------------------------------------------------------------
// COMPUTADORAS
// ------------------------------------------------------------

class SuperComputadora {
	const equipos = []
	var totalDeComplejidadComputada = 0
	
	method estaActivo() = true
	
	method equiposActivos(){
		return equipos.filter { equipo => equipo.estaActivo()}
	}
	
	method capacidadDeComputo(){
		return equipos.sum {equipo => equipo.computo()}
	}
	
	method consumoElectrico(){
		return equipos.sum {equipo => equipo.consumo()}
	}
	
	method malConfigurada(){
		return self.equipoQueMasConsume() != self.equipoQueMasComputa()
	}
	
	method equipoQueMasConsume(){
		return self.equiposActivos().max {equipo => equipo.consumo()}
	}
	
	method equipoQueMasComputa(){
		return self.equiposActivos().max {equipo => equipo.computo()}
	}
	
	method computar(problema){ // for each solo darle una orden a multiples objetos 
		self.equiposActivos().forEach {equipo => equipo.computar(new Problema(complejidad = problema.complejidad()/ self.equiposActivos().size()))}
		totalDeComplejidadComputada += problema.complejidad()
	}
}

// ------------------------------------------------------------
// EQUIPOS
// ------------------------------------------------------------

class Equipo {
	var property modo
	var property estaQuemado = false
	
	method estaActivo(){
		return !estaQuemado && self.computo()
	}
	method consumo() {
		return modo.consumoDe(self)
	}
	method computo() {
		return modo.computoDe(self)
	}
	
	method consumoBase()
	method computoBase()
	method computoExtraPorOverclock ()
	
	method computar(problema){
		if(problema.complejidad() > self.computo()){
			throw new DomainException(message= "Capacidad excedida")
		} 
		modo.realizoComputo(self)
	}
}

class A105 inherits Equipo {
	
	override method consumoBase() = 300
	override method computoBase() = 600
	
	override method computoExtraPorOverclock(){
		return self.computoBase() * 0.3
	}
	
	override method computar(problema){
		 if (problema.complejidad() < 5){
			throw new DomainException(message="Error de fabrica")
		}
		super(problema)
		
	}
	
	
}

class B2 inherits Equipo {
	const  microchips
	
	override method consumoBase(){
		return 10 + 50 * microchips
	}
	
	override method computoBase(){
		return 800.min(100 * microchips)
	}
	
	override method computoExtraPorOverclock(){
		return microchips*20
	}
	
}



// ------------------------------------------------------------
// MODOS
// ------------------------------------------------------------

object standard {
	method consumoDe(unEquipo){
		return unEquipo.consumoBase()
	}
	method computoDe(unEquipo){
		return unEquipo.computoBase()
	}
	
	method realizoComputo(equipo) {}
	
}

class Overclock {
	var usosRestantes
	
	method consumoDe(unEquipo){
		return unEquipo.consumoBase() * 2
	}
	method computoDe(unEquipo){
		return unEquipo.computoBase() + unEquipo.computoExtraPorOverclock()
	}
	
	method realizoComputo(equipo){
		if(usosRestantes == 0){
			equipo.estaQuemado(true)
			throw new DomainException(message= "Equipo Quemado")
		}
		usosRestantes -= 1
	}
}

class AhorroDeEnergia {
	var computosRealizados = 0
	
	method consumoDe(unEquipo) = 200
	method computoDe(unEquipo){
		return self.consumoDe(unEquipo) / unEquipo.consumoBase() * unEquipo.computoBase()
	}
	
	method realizoComputo(equipo){
		computosRealizados += 1
		if(computosRealizados % self.periodicidadDeError() == 0) throw new DomainException(message="Corriendo monitor")
	}
	
	method periodicidadDeError() = 17
}

class APruebaDeFallos inherits AhorroDeEnergia {
	override method periodicidadDeError() = 100
	
	override method computoDe(equipo) {
		return super(equipo) / 2
	}
}

// ------------------------------------------------------------
// PROBLEMAS
// ------------------------------------------------------------

class Problema {
	const property complejidad
}











