import QtQuick 2.7
import io.calamares.ui 1.0

// Editor lock: heading exact. Minimal page — notes-20260820 welcomeq
// failed to load ("Welcome Loading failed") with versionless imports,
// Branding.imagePath, and config.languagesModel.
//
// 2026-09-03: re-added a Branding.imagePath() image, this time with the
// required "import io.calamares.ui 1.0" (the missing piece before) and
// nothing else from that failed attempt — no Kirigami, no Config/
// config.languagesModel, no versionless imports. Call shape matches
// upstream calamares/calamares src/modules/welcomeq/welcomeq.qml exactly:
// source: "file:/" + Branding.imagePath(Branding.ProductWelcome)
Item {
    width: 800
    height: 480

    Text {
        id: welcomeHeading
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 24
        width: parent.width - 48
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        textFormat: Text.PlainText
        font.pixelSize: 22
        font.bold: true
        text: "Welcome to the Lunduke Computer Operating System"
    }

    Image {
        id: welcomeImage
        anchors.top: welcomeHeading.bottom
        anchors.topMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 48
        // imagePath() returns a full filesystem path; the "file:/" prefix
        // makes QML treat it as a file URL instead of a path relative to
        // this QML file's own location.
        source: "file:/" + Branding.imagePath(Branding.ProductWelcome)
        fillMode: Image.PreserveAspectFit
    }
}
