function sumNegativesBetweenMinMax(A) {
  if (!Array.isArray(A) || A.length < 2) return 0;

  let iMax = 0, iMin = 0;
  for (let i = 1; i < A.length; i++) {
    if (A[i] > A[iMax]) iMax = i;
    if (A[i] < A[iMin]) iMin = i;
  }

  const left = Math.min(iMax, iMin);
  const right = Math.max(iMax, iMin);

  let sum = 0;
  for (let i = left + 1; i < right; i++) {
    if (A[i] < 0) sum += A[i];
  }
  return sum;
}

// --- Тест-кейсы (исправленные) ---
const tests = [
  { arr: [3, -2, 5, -4, 1, -6, 7],      expected: 0,  note: "min и max соседние" },
  { arr: [1, -2, 5, -4, 7, -3, -6, 2],  expected: -3, note: "между ними [-3]" },
  { arr: [5, 10, -1, -5, -3, -7, 0],    expected: -9,  note: "между ними [-5, -3, -7]" },
  { arr: [-5, -3, -2, -7, -9],          expected: -7,  note: "max=-2, min=-9, между ними [-7]" },
  { arr: [10, -1, -2, -3, -8, 5, 2],    expected: -6, note: "между ними [-1,-2,-3]" },
];

// --- Автопроверка ---
tests.forEach(({ arr, expected }, i) => {
  const got = sumNegativesBetweenMinMax(arr);
  const ok = got === expected ? "OK" : "FAIL";
  console.log(`Тест ${i + 1}: ${ok} | ожидается ${expected}, получено ${got}`, arr);
});