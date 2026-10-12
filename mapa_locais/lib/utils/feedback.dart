import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

String errorMessage(Object error) {
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' =>
        'Acesso negado. Confira a conta autorizada e as regras do Firestore.',
      'unavailable' =>
        'Serviço indisponível. Confira a conexão e tente novamente.',
      'not-found' => 'Este local já foi removido. Atualize a lista.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => 'Não foi possível entrar. Confira e-mail e senha.',
      'operation-not-allowed' =>
        'Habilite o provedor de autenticação no Firebase.',
      _ =>
        'Não foi possível concluir a operação (${error.code}). Tente novamente.',
    };
  }
  return 'Não foi possível concluir a operação. Tente novamente.';
}

void feedback(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
