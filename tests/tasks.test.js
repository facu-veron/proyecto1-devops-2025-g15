// ============================================================
// TESTS DE INTEGRACIÓN – TASKS API
// ------------------------------------------------------------
// Este archivo contiene tests de integración para la API
// de tareas (TODO API).
//
// Se utiliza:
// - Jest como framework de testing
// - Supertest para simular requests HTTP
//
// Los tests validan el flujo completo CRUD:
// Crear → Listar → Obtener → Actualizar → Eliminar
// ============================================================

// Librería para simular requests HTTP a la aplicación

// Librería para simular requests HTTP a la aplicación
const request = require('supertest');
// Importa la app Express sin levantar el servidor
const app = require('../src/app');
// Módulos de Node.js para manejo de archivos
const fs = require('fs');
const path = require('path');
// Ruta al archivo de base de datos SQLite
const dbFile = path.join(__dirname, '../data/todo.db');

// ------------------------------------------------------------
// HOOK: beforeEach
// ------------------------------------------------------------
// Se ejecuta antes de cada test.
// Elimina la base de datos para garantizar:
// - Aislamiento entre tests
// - Resultados determinísticos
// ------------------------------------------------------------
beforeEach(() => {
  // Limpiar DB antes de cada test
  if (fs.existsSync(dbFile)) fs.unlinkSync(dbFile);
});

// ------------------------------------------------------------
// SUITE DE TESTS: TASKS API
// ------------------------------------------------------------
describe('Tasks API', () => {

  // ----------------------------------------------------------
  // TEST: Flujo completo CRUD
  // ----------------------------------------------------------
  // Valida todas las operaciones principales sobre tareas
  // en una única prueba:
  // - POST   /tasks
  // - GET    /tasks
  // - GET    /tasks/:id
  // - PUT    /tasks/:id
  // - DELETE /tasks/:id
  // ----------------------------------------------------------
  test('create, list, get, update, delete', async () => {

    // --------------------------------------------------------
    // CREATE: Crear una nueva tarea
    // --------------------------------------------------------
    const create = await request(app).post('/tasks').send({ title: 'Test task' });
    expect(create.statusCode).toBe(201);
    expect(create.body.title).toBe('Test task');
    // Guarda el ID generado para los siguientes pasos
    const id = create.body.id;

    // --------------------------------------------------------
    // LIST: Listar todas las tareas
    // --------------------------------------------------------
    const list = await request(app).get('/tasks');
    expect(list.statusCode).toBe(200);
    expect(Array.isArray(list.body)).toBeTruthy();

    // --------------------------------------------------------
    // GET: Obtener una tarea por ID
    // --------------------------------------------------------
    const get = await request(app).get(`/tasks/${id}`);
    expect(get.statusCode).toBe(200);
    expect(get.body.id).toBe(id);

    // --------------------------------------------------------
    // UPDATE: Actualizar el estado de la tarea
    // --------------------------------------------------------
    const upd = await request(app).put(`/tasks/${id}`).send({ completed: true });
    expect(upd.statusCode).toBe(200);
    expect(upd.body.completed).toBe(true);

    // --------------------------------------------------------
    // DELETE: Eliminar la tarea
    // --------------------------------------------------------
    const del = await request(app).delete(`/tasks/${id}`);
    expect(del.statusCode).toBe(200);
    expect(del.body.deleted).toBeTruthy();
  // Timeout extendido para evitar falsos fallos en CI
  }, 10000);
});

// --------------------------------------------------------------

// Observaciones técnicas (NO aplicadas)

// Tests CRUD en un único caso
//   Facilita la lectura
//   Pero si falla un paso, no se ejecutan los siguientes
//   En producción se suelen separar por operación

// --------------------------------------------
// Dependencia de SQLite como archivo local

//   Adecuado para tests simples
//   No escala bien a tests paralelos
//   En suites grandes se usan DBs en memoria o mocks

// --------------------------------------------
// No se validan errores o casos negativos

//   No se testean:
//   IDs inexistentes
//   Requests inválidas
//   Errores de validación

// --------------------------------------------
// Tests de integración, no unitarios

//   Se testea el stack completo (routes + controllers + DB)
//   Correcto para este proyecto
//   Complementable con tests unitarios

// --------------------------------------------------------------