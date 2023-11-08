// ----------------------------------------------------
// PERSONAJES
// ----------------------------------------------------

class Personaje {
	var casa
	const conyugues = #{}
	const acompaniantes = #{}
	var personalidad
	
	method patrimonio(){
		return casa.patrimonioPorMiembro()
	}	
	
	method puedeCasarseCon(otroPersonaje){
		return casa.puedeCasarse(self, otroPersonaje) && otroPersonaje.casa().puedeCasarse(otroPersonaje, self)
	}
	
	method casarse(otroPersonaje){
		if(!self.puedeCasarseCon(otroPersonaje)){
			self.error("No pueden casarse")
		}
		conyugues.add(otroPersonaje)
		otroPersonaje.conyugues().add(self)
	}
	
	method estaVivo() = true
	
	method estaSolo(){
		return acompaniantes.isEmpty()
	}
	
	method aliados(){
		return acompaniantes.union(conyugues).union(casa.miembros())
	}
	
	method esPeligroso(){
		return self.estaVivo() && (self.sumaMonedasAliados() > 10000 || self.todosConyuguesDeCasaRica() || self.alianzaConAlguienPeligroso())
	}
	
	method sumaMonedasAliados(){
		return self.aliados().sum {aliado => aliado.patrimonio()}
	}
	
	method todosConyuguesDeCasaRica(){
		return conyugues.all{ conyugue => conyugue.casa().esRica()}
	}
	
	method alianzaConAlguienPeligroso(){
		return self.aliados().any {aliado => aliado.esPeligroso()}
	}
	
	method realizarAccion(objetivo){
		personalidad.realizarAccion(objetivo)
	}
	
	method estaSoltero(){
		return conyugues.isEmpty()
	}
	
	method derrochar(porcentaje){
		casa.reducirPatrimonio(porcentaje)
	}
	
	method crearConspiracion(objetivoCons, complotadosCons){
		new Conspiracion(objetivo= objetivoCons, complotados = complotadosCons)
	}
	
	
}

// ----------------------------------------------------
// CASAS
// ----------------------------------------------------

class Casa{
	var property patrimonio
	var property ciudad
	const miembros = #{}
	
	method esRica(){
		return patrimonio > 1000
	}
	
	method reducirPatrimonio(porcentaje){
		patrimonio -= patrimonio*porcentaje
	}
	
	method patrimonioPorMiembro(){
		return patrimonio / miembros.size()
	}
	
}

class Lannister inherits Casa{
	
	method sePuedeCasar(unPersonaje, otroPersonaje){
		return unPersonaje.estaSoltero()
	}
	
}

class Stark inherits Casa{
	
	method sePuedeCasar(unPersonaje, otroPersonaje){
		return !miembros.contains(otroPersonaje)
	}
	
}

class GuardiaDeLaNoche inherits Casa{
	
	method sePuedeCasar(unPersonaje, otroPersonaje) = false
}

// ----------------------------------------------------
// ACOMPANIANTES
// ----------------------------------------------------

object dragon{
	
	method patrimonio() = 0
	
	method esPeligroso() = true
}

object lobo{
	var property raza = hurago
	
	method patrimonio() = 0
	
	method esPeligroso(){
		raza.esPeligroso()
	}
}

object hurago{
	
	method esPeligroso() = true
}

// ----------------------------------------------------
// CONSPIRACIONES
// ----------------------------------------------------

class Conspiracion{
	var objetivo
	const complotados = #{}
	var seEjecuto = false
	
	method organizarConspiracion(){
		if(!objetivo.esPeligroso()){
			self.error("No se puede organizar la conspiracion")
		}
		complotados.forEach{ complotado => complotado.realizarAccion(objetivo)}
		seEjecuto = true
	}
	
	method cuantosTraidoresHay(){
		return complotados.filter{complotado => complotado.aliados().contains(objetivo)}.size()
	}
	
	method objetivoCumplido(){
		return seEjecuto && !objetivo.esPeligroso() // como pongo que la conspiracion se ejecuto?
	}
	
}



// ----------------------------------------------------
// PERSONALIDADES
// ----------------------------------------------------

object sutil{
	method realizarAccion(objetivo){
		objetivo.casarse() // casaMasPobre.miembros().filter {miembro => miembro.estaSoltero() && miembro.estaVivo()}.anyOne()
	}
	
}

class Asesino{
	method realizarAccion(objetivo){
		objetivo.estaVivo(false)
	}
}

object asesinoPrecavido inherits Asesino{
	
	override method realizarAccion(objetivo){
		if(objetivo.estaSolo()){
			super(objetivo)
		}
	}
}

object disipado{
	var property porcentaje = 0.5
	
	method realizarAccion(objetivo){
		objetivo.derrochar(porcentaje)
	}
}

class Miedoso{
	
	method realizarAccion(objetivo)	
}
















