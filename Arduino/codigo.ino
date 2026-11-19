
const int sensor = A0;
const int pulsador = 2;
const int led1 = 8;
const int led2 = 9;
const int buzzer = 10;

bool control1 = false;
bool control2 = false;
bool controlBuzzer = false;
bool alerta = false;
bool estadoAlerta = false;

unsigned long tiempoAnterior = 0;

void setup() {
    pinMode(pulsador, INPUT_PULLUP);
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
    pinMode(buzzer, OUTPUT);
    Serial.begin(9600);
}

void loop() {
    int entrada1 = analogRead(sensor) > 512;
    int entrada2 = !digitalRead(pulsador);

    while (Serial.available()) {
        char dato = Serial.read();

        if (dato == 'A') control1 = true;
        if (dato == 'a') control1 = false;
        if (dato == 'B') control2 = true;
        if (dato == 'b') control2 = false;
        if (dato == 'C') controlBuzzer = true;
        if (dato == 'c') controlBuzzer = false;
        if (dato == 'X') {
            alerta = true;
            tiempoAnterior = millis();
            estadoAlerta = true;
        }
        if (dato == 'x') alerta = false;
    }

    bool salida1;
    bool salida2;

    if (alerta) {
        if (millis() - tiempoAnterior >= 700) {
            tiempoAnterior = millis();
            estadoAlerta = !estadoAlerta;
        }

        salida1 = estadoAlerta;
        salida2 = estadoAlerta;
    } else {
        salida1 = entrada1 || control1;
        salida2 = entrada2 || control2;
    }

    bool salidaBuzzer = controlBuzzer || (alerta && estadoAlerta);

    digitalWrite(led1, salida1);
    digitalWrite(led2, salida2);
    digitalWrite(buzzer, salidaBuzzer);

    Serial.print(entrada1);
    Serial.print(",");
    Serial.print(entrada2);
    Serial.print(",");
    Serial.print(salida1);
    Serial.print(",");
    Serial.print(salida2);
    Serial.print(",");
    Serial.print(salidaBuzzer);
    Serial.print(",");
    Serial.print(alerta);
    Serial.print(",");
    Serial.println(controlBuzzer);

    delay(50);
}
