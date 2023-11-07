// -------------------------------------------------------
// VIKINGOS
// -------------------------------------------------------


class Vikingos {
	var property casta
	var oro
	
	method puedeIrDeExpedicion(){
		return casta.puedeIrDeExpedicion(self)
	}
	
	method esProductivo()
	
	method subirAExpedicion(expedicion){
		if(!self.puedeIrDeExpedicion()){
		//	throw new error = ("No puede ir de Expedicion")
		}
		expedicion.agregarVikingo(self)
	}
	
	
	method recibirBotin(cantidad){
		oro += cantidad
	}
	
	method ascender(){
		casta.ascender(self)
	}
	
	method recompensaAscencion()
	
}

// -------------------------------------------------------
// CASTAS
// -------------------------------------------------------

class Casta{
	method puedeIrDeExpedicion(vikingo){
		return vikingo.esProductivo()
	}
	
	method ascender(vikingo)
}

object jarl inherits Casta{
	
	override method puedeIrDeExpedicion(vikingo){
		return super(vikingo) && !vikingo.tieneArmas() 
	}
	
	override method ascender(vikingo){
		vikingo.casta(karl)
		vikingo.recompensaAscencion()
	}
}

object karl inherits Casta {
	
	override method ascender(vikingo){
		vikingo.casta(thrall)
	}
	
}

object thrall inherits Casta{
	
	override method ascender(vikingo){
		// no hace nada
	}

}

// -------------------------------------------------------
// TRABAJOS
// -------------------------------------------------------

class Soldado inherits Vikingos {                      // para heredar tiene que ser algo que no cambie nunca
	var vidasCobradas                                  // por eso las castas no se heredan porque pueden cambiar
	var armas                                          // a lo largo del programa
	
	override method esProductivo(){
		return vidasCobradas > 20 && self.tieneArmas()	
	}
	
	method tieneArmas() = armas > 0
	
	override method recompensaAscencion(){
		armas += 10
	}
}

class Granjero inherits Vikingos {
	var hijos
	var hectareas
	
	override method esProductivo(){
		return hectareas * 2 >= hijos
	}
	
	method tieneArmas() = false
	
	override method recompensaAscencion(){
		hijos += 2
		hectareas += 2
	}
}

// -------------------------------------------------------
// EXPEDICIONES
// -------------------------------------------------------

class Expedicion {
	const vikingos = #{}
	const lugares = #{}
	
	method valeLaPena(){
		return lugares.all {lugar => lugar.valeLaPenaElLugar(self)}
	}
	
	method defensoresDerrotados(){
		return vikingos.size()
	}
	
	method agregarVikingo(vikingo){
		vikingos.add(vikingo)
	}
	
	method realizar(){
		lugares.forEach {lugar => lugar.serInvadido(self)}
		vikingos.forEach {vikingo => vikingo.recibirBotin(self.botinObtenido()/vikingos.size())}
	}
	
	method botinObtenido(){
		return lugares.sum {lugar => lugar.botin()}
	}
	
}


// -------------------------------------------------------
// LUGARES
// -------------------------------------------------------

class Aldea{
	var crucifijos
	
	method botin(expedicion){
		return crucifijos
	}
	
	method valeLaPenaElLugar(expedicion){
		return self.botin(expedicion) >= 15
	}
	
	method serInvadido(expedicion){
		crucifijos = 0
	}
	
}

class AldeaAmurallada inherits Aldea{
	var cantidadMinima
	
	 override method valeLaPenaElLugar(expedicion){
	 	return super(expedicion) && expedicion.vikingos().size() >= cantidadMinima
	 }
}

class Capital{
	var factorRiqueza
	var defensores
	
	method botin(expedicion){
		return expedicion.defensoresDerrotados() + factorRiqueza
	}
	
	
	method valeLaPenaElLugar(expedicion){
		return self.botin(expedicion) >= expedicion.vikingos().size()*3 
	}
	
	method serInvadido(expedicion){
		defensores -= expedicion.defensoresDerrotados()
	}
}
























