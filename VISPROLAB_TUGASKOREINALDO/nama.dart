import 'dart:io'; // Import library untuk input/output
import 'dart:async';
import 'dart:math'; // Untuk random

class Node {
  String? data;
  Node? next;

  Node(this.data);
}

Future<void> delay(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

void moveTo(int row, int col) {
  stdout.write('\x1B[${row};${col}H');
}

getScreenSize() {
  return [stdout.terminalColumns, stdout.terminalLines];
}

void clearScreen() {
  print("\x1B[2J\x1B[0;0H"); // clear entire screen, move cursor to 0;0
}

// Fungsi untuk memasukkan node baru ke posisi tertentu
Node insertNodeAtPosition(Node head, Node newNode, int position) {
  if (position == 1) {
    newNode.next = head;
    return newNode;
  }

  Node? currentNode = head;
  int i = 1;
  if (position != 0) {
    while (currentNode!.next != null && i < position - 1) {
      currentNode = currentNode.next;
      i++;
    }
  } else {
    while (currentNode!.next != null) {
      currentNode = currentNode.next;
      i++;
    }
  }

  newNode.next = currentNode.next;
  currentNode.next = newNode;

  return head;
}

// Fungsi untuk mengaktifkan loop pada linked list
Node activateLoop(Node head) {
  Node? currentNode = head;
  while (currentNode!.next != null) {
    currentNode = currentNode.next;
  }
  currentNode.next = head;
  return head;
}

// Fungsi untuk mendapatkan node berikutnya dalam linked list
Node? getNext(Node node) {
  return node.next;
}

// Fungsi untuk membuat teks dari user input
Node craftFromInput(String input) {
  Node head = Node(input[0]);
  for (int i = 1; i < input.length; i++) {
    insertNodeAtPosition(head, Node(input[i]), 0);
  }
  activateLoop(head);
  return head;
}

// Fungsi untuk mendapatkan kode warna ANSI secara acak
String getRandomColor() {
  List<String> colors = [
    '\x1B[31m', // Merah
    '\x1B[32m', // Hijau
    '\x1B[33m', // Kuning
    '\x1B[34m', // Biru
    '\x1B[35m', // Ungu
    '\x1B[36m', // Cyan
    '\x1B[91m', // Merah terang
    '\x1B[92m', // Hijau terang
    '\x1B[93m', // Kuning terang
    '\x1B[94m', // Biru terang
    '\x1B[95m', // Ungu terang
    '\x1B[96m', // Cyan terang
    '\x1B[97m', // Putih terang
    '\x1B[90m', // Abu-abu
    '\x1B[37m', // Putih
    '\x1B[30m', // Hitam
  ];
  Random random = Random();
  return colors[random.nextInt(colors.length)];
}

void main() async {
  // Ambil input dari pengguna
  stdout.write("Masukkan teks untuk animasi: ");
  String? input = stdin.readLineSync();
  
  if (input == null || input.isEmpty) {
    print("Input tidak valid. Keluar dari program.");
    return;
  }

  // Buat linked list dari input pengguna
  Node head = craftFromInput(input);
  clearScreen();

  Node? node = null;
  Random random = Random();
  for (int j = 1; j <= getScreenSize()[1]; j++) {
    if (node == null) {
      node = head;
    }

    // Ganti warna untuk setiap baris
    String color = getRandomColor();

    if (j % 2 != 0) {
      // Baris ganjil: cetak dari kiri ke kanan
      for (int i = 1; i <= getScreenSize()[0]; i++) {
        moveTo(j, i);
        stdout.write(color + node!.data! + '\x1B[0m'); // Tambahkan warna
        node = getNext(node)!;
        await delay(10);
      }
    } else {
      // Baris genap: cetak dari kanan ke kiri
      for (int i = getScreenSize()[0]; i > 0; i--) {
        moveTo(j, i);
        stdout.write(color + node!.data! + '\x1B[0m'); // Tambahkan warna
        node = getNext(node)!;
        await delay(10);
      }
    }
  }
}
