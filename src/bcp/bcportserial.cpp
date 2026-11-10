// serialdll.cpp
#include "pch.h"
#include <windows.h>
#include <iostream>
#include <string>

HANDLE serialPort;

// Função de conexão à porta serial
extern "C" __declspec(dllexport) bool Connect(const char* portName) {
    // Converter const char* para LPCWSTR
    int size = MultiByteToWideChar(CP_UTF8, 0, portName, -1, NULL, 0);
    if (size == 0) {
        std::cerr << "Erro na conversão de string." << std::endl;
        return false;
    }

    wchar_t* widePortName = new wchar_t[size];
    MultiByteToWideChar(CP_UTF8, 0, portName, -1, widePortName, size);

    serialPort = CreateFile(widePortName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

    delete[] widePortName;

    if (serialPort == INVALID_HANDLE_VALUE) {
        std::cerr << "Erro ao conectar à porta serial." << std::endl;
        return false;
    }

    DCB dcbSerialParams = { 0 };
    dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

    if (!GetCommState(serialPort, &dcbSerialParams)) {
        std::cerr << "Erro ao obter o estado da porta serial." << std::endl;
        CloseHandle(serialPort);
        return false;
    }

    dcbSerialParams.BaudRate = CBR_9600;  // Taxa de transmissão: 9600 bps
    dcbSerialParams.ByteSize = 8;         // Tamanho do byte: 8 bits
    dcbSerialParams.StopBits = ONESTOPBIT; // 1 stop bit
    dcbSerialParams.Parity = NOPARITY;     // Sem paridade

    if (!SetCommState(serialPort, &dcbSerialParams)) {
        std::cerr << "Erro ao configurar o estado da porta serial." << std::endl;
        CloseHandle(serialPort);
        return false;
    }

    return true;
}

// Função para ler da porta serial e retornar um ponteiro para char
extern "C" __declspec(dllexport) char* ReadString() {
    static char receivedData[256]; // Tamanho do buffer
    DWORD bytesRead;

    memset(receivedData, 0, sizeof(receivedData)); // Inicializar o buffer com zeros

    while (true) {
        if (ReadFile(serialPort, receivedData, sizeof(receivedData) - 1, &bytesRead, NULL)) {
            if (bytesRead < sizeof(receivedData) - 1) {
                break; // Leitura concluída
            }
        }
        else {
            std::cerr << "Erro ao ler dados da porta serial." << std::endl;
            break;
        }
    }

    // Limpar o buffer de recepção após a leitura (também após um erro)
    PurgeComm(serialPort, PURGE_RXCLEAR);

    return receivedData;
}

// Função de desconexão da porta serial
extern "C" __declspec(dllexport) void Disconnect() {
    CloseHandle(serialPort);
}

