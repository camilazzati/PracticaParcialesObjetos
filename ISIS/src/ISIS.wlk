// -----------------------------------------------------------
// EMPLEADOS
// -----------------------------------------------------------

class Empleado {
	var salud
	const habilidades = #{}
	var puesto
	
	method estaIncapacitado(){
		return salud < puesto.saludCritica()
	}
	
	
	method puedeUsar(unaHabilidad){
		return !self.estaIncapacitado() && self.poseeHabilidad(unaHabilidad)
	}
	
	method poseeHabilidad(unaHabilidad){
		return habilidades.contains(unaHabilidad)
	}
	
	method recibirDanio(danio){
		salud -= danio
	}
	
	method finalizarMision(mision){
		if(self.estaVivo()){
			self.completarMision(mision)
		}
	}
	
	method completarMision(mision){
		puesto.completarMision(mision, self)
	}
	
	method estaVivo(){
		return salud > 0
	}
	
	method aprender(habilidad){
		habilidades.add(habilidad)
	}
	
}

class Jefe inherits Empleado {
	const subordinados = #{}
	
	override method puedeUsar(unaHabilidad){
		return super(unaHabilidad) || subordinados.any {subordinado => subordinado.puedeUsar(unaHabilidad)}
	}
}

class Equipo {
	const miembros = #{}
	
	method puedeUsar(unaHabilidad){
		return miembros.any {empleado => empleado.puedeUsar(unaHabilidad)}
	}
	
	method recibirDanio(danio){
		return miembros.forEach {empleado => empleado.recibirDanio(danio/3)}
	}
	
	method finalizarMision(mision){
		miembros.forEach {empleado => empleado.finalizarMision(mision)}
	}
}

// -----------------------------------------------------------
// PUESTOS
// -----------------------------------------------------------

object espia {
	
	method saludCritica() = 15
	
	method completarMision(mision, empleado){
		mision.enseniarHabilidades(empleado)
	}
}

class Oficinista {
	var estrellas
	
	method saludCritica(){
		return 40-5* estrellas
	}
	
	method completarMision(mision, empleado){
		estrellas += 1
		if(estrellas == 3){
			empleado.puesto(espia)
		}
	}
	

	
}

// -----------------------------------------------------------
// MISIONES
// -----------------------------------------------------------

class Mision {
	const habilidadesRequeridas = #{}
	var peligrosidad
	
	method serCumplidaPor(asignado) { // empleado o equipo
		if(!self.reuneHabilidadesRequeridas(asignado)){
			self.error("La mision no se puede cumplir")
		}
		asignado.recibirDanio(peligrosidad)
		asignado.finalizarMision(self)
	}
	
	method reuneHabilidadesRequeridas(asignado){
		return habilidadesRequeridas.all{habilidad => asignado.puedeUsar(habilidad)}
	}
	
	method enseniarHabilidades(empleado){
		self.habilidadesQueNoPosee(empleado).forEach{habilidad => empleado.aprender(habilidad)}
	}
	
	method habilidadesQueNoPosee(empleado){
		return habilidadesRequeridas.filter {habilidad => !empleado.poseeHabilidad()}
	}
	
/* 
	
	method realizarMision(unEquipo) {
		if (habilidadesRequeridas.all {habilidadRequerida => self.habilidadPerteneceAlEquipo(habilidadRequerida, unEquipo)}) {
			unEquipo.forEach { empleado => empleado.recibirDanio(peligrosidad)}
			if(unEquipo.sobrevivio()){
				unEquipo.forEach {empleado => empleado.puesto().recompensaMision(habilidadesRequeridas, empleado)}
			}
		}
	}
	
	method habilidadPerteneceAlEquipo(habilidadRequerida, unEquipo){
		unEquipo.forEach { empleado => empleado.habilidades().contains(habilidadRequerida)}
	}
	
*/
}







