importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Firebase configuration
firebase.initializeApp({
  apiKey: 'AIzaSyBG6NsWogPHgqGzSgEkCscb9yf6kb-epMQ',
  authDomain: 'laboratory2-19376.firebaseapp.com',
  projectId: 'laboratory2-19376',
  storageBucket: 'laboratory2-19376.firebasestorage.app',
  messagingSenderId: '35707398349',
  appId: '1:35707398349:web:83eff4a39eac309b3fe184',
});

// Initialize Firebase Messaging
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log('[firebase-messaging-sw.js] Received background message: ', payload);

  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png', // Change this to the path of your notification icon
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
