// UNUSED: branding.desc uses YAML image sequence (API -1). QML stayed white on LCOS.
import QtQuick 2.0
import calamares.slideshow 1.0

// Install/exec slideshow (copying-files). 6 desktop screenshots, cover-cropped 680x360.
Presentation {
    id: presentation
    anchors.fill: parent

    function nextSlide() {
        presentation.goToNextSlide();
    }

    function onActivate() {
        presentation.currentSlide = 0;
    }

    function onLeave() {
    }

    Timer {
        id: advanceTimer
        interval: 8000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-01.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-02.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-03.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-04.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-05.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
    Slide {
        anchors.fill: parent
        Image {
            source: "lcos-05-slide-06.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
}
