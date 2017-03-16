import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:resize_sensor_component/resize_sensor_component.dart';

main() {
  bootstrap(ResizeSensorExampleComponent);
}

@Component(
    selector: 'resize-sensor-example',
    directives: const [ResizeSensorComponent],
    template: r'''
    <div style="display: inline-block">
        <span>width:{{width}}</span>
        <span>height:{{height}}</span>
        <textarea>change textarea size to see resize event</textarea>
        <resize-sensor (resize)="resize($event)"></resize-sensor>
    </div>
        ''')
class ResizeSensorExampleComponent {
  int width = 0;
  int height = 0;
  void resize(ResizeEvent event) {
    width = event.width;
    height = event.height;
  }
}
