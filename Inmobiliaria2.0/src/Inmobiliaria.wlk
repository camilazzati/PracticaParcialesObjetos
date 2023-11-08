// ------------------------------------------------------------------
// OPERACIONES
// ------------------------------------------------------------------


class Operacion {
	const inmueble
	var estado
	
	method comision()
	
	method reservarPara(cliente){
		estado.reservarPara(self, cliente)
	}
}

class Venta inherits Operacion{
	var porcentaje
	
	override method comision(){
		return inmueble.valor() * porcentaje
	}
}

class Alquiler inherits Operacion{
	const meses
	
	override method comision(){
		return meses * inmueble.valor() / 50000
	}
	
}

// ------------------------------------------------------------------
// ESTADOS
// ------------------------------------------------------------------

object reservado{
	
}



// ------------------------------------------------------------------
// INMUEBLES
// ------------------------------------------------------------------

class Inmueble{
	var tamanio
	var cantidadAmbientes
	var operacion
	var property zona
	
	method valor() = zona.valor() + self.valorParticular()
	method valorParticular()
}

class Casa inherits Inmueble{
	var property valorParticular
	
	override method valorParticular() = valorParticular
}

class Ph inherits Inmueble{
	
	override method valorParticular(){
		return 500000.max(14000 * tamanio)
	}
}

class Departamento inherits Inmueble{
	
	override method valorParticular(){
		return 350000 * cantidadAmbientes
	}
}

// ------------------------------------------------------------------
// PERSONAS
// ------------------------------------------------------------------

object inmobiliaria{
	const empleados = #{}
	
	method mejorEmpleadoSegun(criterio){
		return empleados.max{empleado => criterio.obtenerCriterio(empleado)}
	}
}

class Empleado{
	const reservas = #{}
	const operacionesCerradas = #{}
	
	method reservar(operacion, cliente){
		operacion.reservarPara(cliente)
		reservas.add(operacion)
	}
	
	method concretarOperacion(operacion, cliente){
		operacion.concretarPara(cliente)
		operacionesCerradas.add(operacion)
	}
	
	method comisionesTotales(){
		return operacionesCerradas.forEach{operacion => operacion.comision()}
	}
	
	method vaAtenerProblemas(otroEmpleado){
		return self.operoEnMismaZona(otroEmpleado) && (self.concretoOperacionReservadaPor(otroEmpleado) || otroEmpleado.concretoOperacionReservadaPor(self))
	}
	
	method operoEnMismaZona(otroEmpleado){
		return self.zonasEnLasQueOpero().any{zona => otroEmpleado.operoEnZona(zona)}
	}
	
	method zonasEnLasQueOpero(){
		return operacionesCerradas.map{ operacion => operacion.zona()}
	}
	
	method operoEnZona(zona){
		return self.zonasEnLasQueOpero().contains(zona)
	}
	
	method concretoOperacionReservadaPor(otroEmpleado){
		return operacionesCerradas.any {operacion => otroEmpleado.reservas().contains(operacion)}
	}
}

class Cliente{
	
}

// ------------------------------------------------------------------
// CRITERIOS
// ------------------------------------------------------------------

object totalDeComisionesPorOperacionesCerradas {
	method obtenerCriterio(empleado){
		return empleado.comisionesTotales()
	}
}

object cantidadDeOperacionesCerradas {
	method obtenerCriterio(empleado){
		return empleado.operacionesCerradas().size()
	}
}

object cantidadDeReservas{
	method obtenerCriterios(empleado){
		return empleado.reservas().size()
	}
}








































