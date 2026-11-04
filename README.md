# Escuela de Natación

Una escuela de natación nos ha solicitado desarrollar un software para gestionar sus distintos cursos.

## 1. Inscripción a Cursos

Se manejan cuatro estilos de natación: **crol**, **pecho**, **espalda** y **mariposa**.  

De cada estudiante se conoce:
- Cuáles de esos estilos domina (podría no dominar ninguno).
- Su edad.

Para que un estudiante pueda inscribirse a un curso, deben cumplirse **todas** las siguientes condiciones:
- **No estar ya inscripto** en el curso.
- Que el curso tenga **vacantes disponibles** (la cantidad de inscriptos debe ser menor al cupo máximo).
- Que el **docente asignado** esté habilitado para dictar clases al estudiante en ese curso:
  - Un **docente dedicado** a un estilo puede dictar clases solo a estudiantes que dominen dicho estilo.
  - Un **docente externo** tiene un **límite máximo de estudiantes menores de 13 años por curso**.  Este límite es un número específico configurado para cada docente externo. Puede tener inscriptos mayores a 13 sin restricciones.
  - Hay **docentes básicos** que pueden dictar clases a cualquier estudiante.

- Además, el **objetivo del curso** impone requisitos adicionales:
  - Los cursos **base** aceptan estudiantes que dominen al menos un estilo, o bien que el docente posea título profesional de guardavidas.
  - Los cursos **"escuelita de niños"** siguen las reglas de los cursos base, pero además **solo aceptan estudiantes menores de 13 años**.
  - Los cursos **terapéuticos** requieren que el estudiante domine al menos uno de los **estilos relajantes**. Se consideran relajantes **pecho** y **espalda**; mientras que **crol** y **mariposa** no lo son.

### Requerimientos

- Conocer todos los estudiantes inscriptos en un curso.
- Verificar si un estudiante puede inscribirse a un curso.
- Inscribir un estudiante en un curso (¡cuidado con los casos que no cumplen los requisitos!).

> Los ejemplos y casos de prueba se encuentran en el archivo de tests.

---

## 2. Recaudación

La escuela dicta varios cursos y se desea registrar el ingreso mensual.  
El sistema debe:
- Conocer la cantidad de dinero guardado en la escuela.
- Actualizar ese monto cuando se cobre la recaudación.

Por ejemplo, si se tiene $20.000 guardados y se recauda $10.000, el nuevo valor del dinero guardado será de $30.000.

La **recaudación mensual de la escuela** es la suma de las recaudaciones de todos los cursos:

```
suma(recaudación_curso_1, ..., recaudación_curso_n)
```

La **recaudación de un curso** se calcula como:

```
recaudación_bruta - lo que cobra el docente por ese curso
```

### Recaudación Bruta según el objetivo del Curso

- **Curso Base:**  
  Recauda $20 por inscripto, aplicando los siguientes descuentos según los estilos que éste domine:
  - **crol** y **pecho:** -$2 cada uno.
  - **Espalda:** -$1.
  - **Mariposa:** -$3.

- **Escuelita de Niños:**  
  Igual que en el curso base, pero suma $500 extra debido a un incentivo municipal.

- **Curso Terapéutico:**  
  La recaudación bruta se fija para cada curso.

### Honorarios de Docentes

- **Docente Básico:** Cobra una base de 20 más el 10% de la recaudación bruta del curso:

```
20 + recaudación_bruta_del_curso * 0.1
```

- **Docente Dedicado:** similar al básico, solo que usa el 15%

```
20 + recaudación_bruta_del_curso * 0.15
```

- **Docente externo:** Similar al básico, pero recibe un extra de 3 pesos por cada inscripto.
```
20 + recaudación_bruta_del_curso * 0.1 + 3 * cantidad_inscriptos_del_curso
```

### Requerimientos

- Conocer el dinero guardado en la escuela.
- Cobrar la recaudación mensual.

> Los ejemplos y casos de prueba se encuentran en el archivo de tests.

---

## 3. Consultas

Se deben poder realizar las siguientes consultas:
Nota: prestar atención a la distribución de responsabilidades!

- **Curso con un estilo:**  
  Encontrar un curso que tenga algún inscripto que domine un estilo específico, por ejemplo uno en el cual algún estudiante domine mariposa.

- **Cursos infantiles:**  
  Cursos en los que todos los estudiantes tienen menos de 13 años.

- **Docentes infantiles:**  
  Docentes que imparten al menos un curso infantil.


> Los ejemplos y casos de prueba se encuentran en el archivo de tests.
