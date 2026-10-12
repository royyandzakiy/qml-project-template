import QtQuick
import QtTest
import App

// Integration smoke test: the real Main.qml with the real C++ CounterViewModel, driven by clicks.
TestCase {
    id: testCase
    name: "MainWindow"
    when: windowShown

    Component {
        id: mainComponent
        Main {}
    }

    function test_clickUpdatesLabel() {
        const window = createTemporaryObject(mainComponent, testCase);
        verify(window);
        verify(waitForRendering(window.contentItem));

        const label = findChild(window.contentItem, "counterLabel");
        compare(label.text, "Not clicked yet");

        mouseClick(findChild(window.contentItem, "incrementButton"));
        compare(label.text, "Clicked once");

        mouseClick(findChild(window.contentItem, "resetButton"));
        compare(label.text, "Not clicked yet");
    }
}
