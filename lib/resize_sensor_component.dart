import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

/// Provide resize event on element
/// Inspired by https://github.com/flowkey/resize-sensor
///
/// If there is NOT relative or absolute position on parent element of <resize-sensor>, relative is set.
/// It might disable clicks on absolute icons around if wrong z-index is set !!!
///
/// Resize sensor stacks changes, so zero sizes are omitted on component repaint
///
/// Not reliably tested :-(
///
/// Example usage:
///
///    @Component(
///       selector: 'my-component',
///       directives: const[ResizeSensor],
///       template: r'''
///       <div>
///         some content
///         <resize-sensor (resize)="$event"></resize-sensor>
///       </div>
///    ''')
///    class MyComponent{
///      void resize(ResizeEvent event){
///        print("${event.width} ${event.height}");
///      }
///    }
@Component(
    selector: 'resize-sensor',
    styleUrls: const ["resize_sensor.scss.css"],
    template: r'''
        <div class="resize_sensor__cont">
          <div #expand (scroll)="onScroll()" class="resize_sensor__cont" >
             <div class="resize_sensor__inner" style="width: 100000px; height: 100000px;"></div>
          </div>
           <div #shrink (scroll)="onScroll()" class="resize_sensor__cont">
             <div class="resize_sensor__inner" style="width: 200%; height: 200%"></div>
          </div>
        </div>
    ''')
class ResizeSensorComponent implements OnInit {
  HtmlElement _expandElement;
  HtmlElement _shrinkElement;
  HtmlElement host;
  ResizeEvent resizeEvent = new ResizeEvent();
  bool active = false;

  ResizeSensorComponent(ElementRef hostElement) {
    dynamic _host = hostElement.nativeElement;
    if(_host is HtmlElement){
      host = _host;
    }
  }

  @Output("resize")
  final resize = new EventEmitter<ResizeEvent>(false);

  @ViewChild('expand')
  set expand(ElementRef elementRef) {
    _expandElement = (elementRef.nativeElement as HtmlElement);
  }

  @ViewChild('shrink')
  set shrink(ElementRef elementRef) {
    _shrinkElement = (elementRef.nativeElement as HtmlElement);
  }

  void onScroll() {
    if(!active)return;
    resizeEvent._sizesRecheck(resize);
    reset();
  }

  @override
  void ngOnInit() {
    reset();
    if(host.parent == null){
      // if *ngIf used, component is created detached
      // Component is not attached in DOM. No idea why, no idea what to do.
    }else{
      resizeEvent.sizeCheckedElement = host.parent;
      active = true;
    }
  }

  void reset() {
    _expandElement.children.first.style
      ..width = "100000px"
      ..height = "100000px";
    _expandElement.scrollLeft = 100000;
    _expandElement.scrollTop = 100000;
    _shrinkElement.scrollLeft = 100000;
    _shrinkElement.scrollTop = 100000;
  }
}

class ResizeEvent {
  int _width = 0;
  int _height = 0;
  bool _changePending = false;
  Function onHeightChanged = () {};
  Function onWidthChanged = () {};
  Element _sizeCheckedElement;

  Element get sizeCheckedElement => _sizeCheckedElement;

  set sizeCheckedElement(Element value) {
    if (value == null) {
      throw ("detached resize sensor");
    }
    _sizeCheckedElement = value;
    if (_sizeCheckedElement.getComputedStyle().position == 'static') {
      _sizeCheckedElement.style.position = 'relative';
    }
  }

  int get width => _width;

  int get height => _height;

  set width(int value) {
    if (value == _width) return;
    _width = value;
    onWidthChanged();
  }

  set height(int value) {
    if (value == _height) return;
    _height = value;
    onHeightChanged();
  }

  void _sizesRecheck(EventEmitter<ResizeEvent> emitter) {
    if (_changePending) return;
    _changePending = true;
    new Future<Null>.delayed(const Duration(milliseconds: 20)).then((_) {
      _changePending = false;

      int preparedWidth = sizeCheckedElement.offsetWidth;
      int preparedHeight = sizeCheckedElement.offsetHeight;

      if (width != preparedWidth || height != preparedHeight) {
        width = preparedWidth;
        height = preparedHeight;
        emitter.add(this);
      }
    });
  }
}
