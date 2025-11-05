// Базовый класс
class Vehicle {
  move() {
    console.log("Я просто двигаюсь...");
  }
}

// Производные классы
class Car extends Vehicle {
  move() {
    console.log("Я еду 🚗");
  }
}

class Plane extends Vehicle {
  move() {
    console.log("Я лечу ✈️");
  }
}

class Boat extends Vehicle {
  move() {
    console.log("Я плыву 🚤");
  }
}

// --- Тестовая программа ---
const vehicles = [
  new Car(),
  new Plane(),
  new Boat()
];

// Полиморфизм — один интерфейс (move), разное поведение
for (const v of vehicles) {
  v.move();
}