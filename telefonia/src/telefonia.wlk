// --------------------------------------------------------
// LINEAS
// --------------------------------------------------------

class Linea {
	// var numeroDeTelefono
	const packsActivos = []
	const consumosRealizados = #{}
	const hoy = new Date()
	
	method costoPromedio(fechaInicio, fechaFin){ 
		return self.soloConsumosQueEstenEntreFechas(fechaInicio, fechaFin).sum {consumo => consumo.costoConsumo()}/self.soloConsumosQueEstenEntreFechas(fechaInicio, fechaFin).size()
	}
	
	method costoTotal(){
		return self.soloConsumosQueEstenEntreFechas(hoy.minusDays(30), hoy).sum {consumo => consumo.costoConsumo()}
	}
	
	method soloConsumosQueEstenEntreFechas(fechaInicio, fechaFin){
		return consumosRealizados.filter{consumo => consumo.estaEntreFechas(fechaInicio, fechaFin)}
	}
	
	method agregarPack(unPack){
		packsActivos.add(unPack)
	}
	
	method puedeSatisfacer(consumo){
		return packsActivos.any {pack => pack.puedeSatisfacer(consumo)}
	}
	
	method realizar(consumo){
		if(!self.puedeSatisfacer(consumo)){
			// error
		}
		packsActivos.filter(self.puedeSatisfacer(consumo)).last().producirGasto(consumo)
		consumosRealizados.add(consumo)
	}
	
	method limpiezaDePacks(){
		packsActivos.filter {pack => !pack.estaVencido() && !pack.estaAcabado()}
	}
}

class Black inherits Linea{
	var deuda
	
	override method realizar(consumo){
		if(!self.puedeSatisfacer(consumo)){
			deuda += consumo.costoConsumo()
	} else
		packsActivos.filter(self.puedeSatisfacer(consumo)).last().producirGasto(consumo)
		consumosRealizados.add(consumo)
	}
}

class Premium inherits Linea{
	override method realizar(consumo){
		packsActivos.filter(self.puedeSatisfacer(consumo)).last().producirGasto(consumo)
		consumosRealizados.add(consumo)
	}
}


// --------------------------------------------------------
// CONSUMOS
// --------------------------------------------------------

class ConsumoInternet {
	var cantidadMB
	var precioPorMB
	var fecha
	
	method costoConsumo() = cantidadMB * precioPorMB 
	
	method estaEntreFechas(fechaInicio, fechaFin){
		return fecha.between(fechaInicio, fechaFin)
	}
	
	method esLlamada() = false
	
}

class ConsumoLlamada {
	var precioFijo
	var precioPorSegundo
	var segundos
	var fecha
	
	method costoConsumo() = precioFijo + segundos * precioPorSegundo 
	
	method estaEntreFechas(fechaInicio, fechaFin){
		return fecha.between(fechaInicio, fechaFin)
	}
	
	method esLlamada() = true
}

// --------------------------------------------------------
// PACKS
// --------------------------------------------------------
class Packs{
	var fechaVencimiento
	
	method puedeSatisfacer(consumo)
	
	method producirGasto(consumo)
	
	
	method estaVencido(){
		return new Date() > fechaVencimiento
	}
	
	method estaAcabado()= false
}

class CreditoDisponible inherits Packs {
	var creditos
	
	override method puedeSatisfacer(consumo){
		return consumo.costoConsumo() < creditos && !self.estaVencido()
	}
	
	override method producirGasto(consumo){
		creditos -= consumo.costoConsumo()
	}
	
	override method estaAcabado(){
		return creditos == 0
	}
	
	
}

class MBLibres inherits Packs {
	var mbs
	
	override method puedeSatisfacer(consumo){                   // esto capaz lo tengo que delegar al consumo?
		return consumo.cantidadMB() < mbs  &&  !self.estaVencido()
	}
	
	override method producirGasto(consumo){
		mbs -= consumo.cantidadMB()
	}
	
	override method estaAcabado(){
		return mbs == 0
	}
}

class LlamadasGratis inherits Packs{
	
	override method puedeSatisfacer(consumo){
		return consumo.esLlamada()  &&  !self.estaVencido()
	}
	
}

class InternetIlimitadoLosFindes inherits Packs{
	
	override method puedeSatisfacer(consumo){
		return ?  && !self.estaVencido()
	}
	
}

class MBLibresMas inherits MBLibres {
	
	override method puedeSatisfacer(consumo){
		if(self.estaAcabado()){
			return consumo.cantidadMB()<=0.1
		}else{
			super(consumo)
		}
	}
}

































