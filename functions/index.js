const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('Conversation/{groupId1}/{chats}/{groupId2}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)
    const to = doc.to
    const sendBy = doc.sendBy
    const isPhoto = doc.isPhoto
    const contentMessage = doc.message

    admin
    	.firestore()
    	.collection('users')
    	.where('uid', '==', to)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().username}`)
          if (userTo.data().tokenNotif && userTo.data().username !== sendBy) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('uid', '==', sendBy)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().username}`)
                  const payload = {
                      notification: {
                        title: `You have a message from "${userFrom.data().username}"`,
                        body: contentMessage,
                        badge: '1',
                        sound: 'default'
                      }
                    }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().tokenNotif, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      })
    return null
  })

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
