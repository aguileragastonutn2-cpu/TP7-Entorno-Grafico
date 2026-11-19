
import processing.serial.*;

Serial arduino;

int e1 = 0;
int e2 = 0;
int l1 = 0;
int l2 = 0;
int buzzer = 0;
int alerta = 0;
int controlBuzzer = 0;

void setup() {
    size(650, 550);
    arduino = new Serial(this, "COM5", 9600);
    arduino.bufferUntil('\n');
}

void draw() {
    background(240);

    fill(30);
    textAlign(CENTER);
    textSize(25);
    text("MONITOREO DE ENTRADAS Y SALIDAS", 325, 45);

    textSize(20);
    text("ENTRADAS", 165, 110);
    text("SALIDAS", 485, 110);

    indicador(165, 165, "E1 - Sensor", e1);
    indicador(165, 255, "E2 - Pulsador", e2);

    indicador(485, 165, "L1 - LED 1", l1);
    indicador(485, 255, "L2 - LED 2", l2);

    indicador(325, 165, "BUZZER", buzzer);

    boton(485, 330, "CONTROL L1");
    boton(485, 390, "CONTROL L2");

    boton(325, 440, alerta == 1 ? "DESACTIVAR ALERTA" : "ALERTA");
    boton(325, 500, controlBuzzer == 1 ? "APAGAR BUZZER" : "ENCENDER BUZZER");

    if (alerta == 1) {
        fill(220, 50, 50);
        textSize(15);
        text("ALERTA ACTIVA", 325, 410);
    }
}

void indicador(int x, int y, String nombre, int estado) {
    fill(30);
    textSize(17);
    text(nombre, x, y - 25);

    if (estado == 1) fill(0, 200, 80);
    else fill(150);

    noStroke();
    ellipse(x, y + 10, 35, 35);

    fill(30);
    text(estado == 1 ? "ON" : "OFF", x, y + 50);
}

void boton(int x, int y, String nombre) {
    rectMode(CENTER);
    fill(80, 130, 210);
    rect(x, y, 180, 40, 8);

    fill(255);
    textSize(14);
    text(nombre, x, y + 5);
}

void mousePressed() {
    if (mouseX > 395 && mouseX < 575) {
        if (mouseY > 310 && mouseY < 350) {
            arduino.write(l1 == 1 ? 'a' : 'A');
        }

        if (mouseY > 370 && mouseY < 410) {
            arduino.write(l2 == 1 ? 'b' : 'B');
        }
    }

    if (mouseX > 235 && mouseX < 415) {
        if (mouseY > 420 && mouseY < 460) {
            arduino.write(alerta == 1 ? 'x' : 'X');
        }

        if (mouseY > 480 && mouseY < 520) {
            arduino.write(controlBuzzer == 1 ? 'c' : 'C');
        }
    }
}

void serialEvent(Serial arduino) {
    String datos = arduino.readStringUntil('\n');

    if (datos != null) {
        datos = trim(datos);
        String[] valores = split(datos, ',');

        if (valores.length == 7) {
            e1 = int(valores[0]);
            e2 = int(valores[1]);
            l1 = int(valores[2]);
            l2 = int(valores[3]);
            buzzer = int(valores[4]);
            alerta = int(valores[5]);
            controlBuzzer = int(valores[6]);
        }
    }
}
