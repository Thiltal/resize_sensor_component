import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

/// Provide resize event on element
/// Inspired by https://github.com/flowkey/resize-sensor
/// Example usage:
///
///    @Component(
///       selector: 'my-component',
///       directives: const[ResizeSensor],
///       template: '''
///       <div #sizeCheckedElement>
///         some content
///         <resize-sensor [resizeEvent]="resizeEvent"></resize-sensor>
///       </div>
///    ''')
///    class MyComponent implements OnInit {
///      HtmlElement _sizeCheckedElement;
///      ResizeEvent resizeEvent = new ResizeEvent();
///      @ViewChild('sizeCheckedElement')
///      set sizeCheckedElement(ElementRef elementRef) {
///        _sizeCheckedElement = elementRef.nativeElement;
///      }
///
///      @override
///      void ngOnInit() {
///        resizeEvent.sizeCheckedElement = _sizeCheckedElement;
///        resizeEvent.onHeightChanged = (){
///          print(resizeEvent.height);
///        };
///        resizeEvent.onWidthChanged = (){
///          print(resizeEvent.height);
///        };
///      }
///    }
@Component(
    selector: 'resize-sensor',
    styleUrls: const ["resize_sensor.scss.css"],
    template: '''
        <div class="resize_sensor__cont">
          <div #expand (scroll)="onScroll()" class="resize_sensor__cont" >
             <div class="resize_sensor__inner" style="width: 100000px; height: 100000px;"></div>
          </div>
           <div #shrink (scroll)="onScroll()" class="resize_sensor__cont">
             <div class="resize_sensor__inner" style="width: 200%; height: 200%"></div>
          </div>
        </div>
    '''
)
class ResizeSensor implements OnInit {
  HtmlElement _expandElement;
  HtmlElement _shrinkElement;
  Element host;
  ResizeEvent resizeEvent = new ResizeEvent();

  ResizeSensor(ElementRef hostElement):host = hostElement.nativeElement{
    resizeEvent.sizeCheckedElement = host.parent;
  }

  @Output("resize")
  final resize = new EventEmitter<ResizeEvent>(false);

  @ViewChild('expand')
  set expand(ElementRef elementRef) {
    _expandElement = elementRef.nativeElement;
  }

  @ViewChild('shrink')
  set shrink(ElementRef elementRef) {
    _shrinkElement = elementRef.nativeElement;
  }

  void onScroll() {
    resizeEvent._sizesRecheck();
    reset();
  }

  @override
  void ngOnInit() {
    reset();
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
  HtmlElement _sizeCheckedElement;

  HtmlElement get sizeCheckedElement => _sizeCheckedElement;

  set sizeCheckedElement(Element value) {
    if(value == null){
      throw("detached resize sensor");
    }
    _sizeCheckedElement = value;
    if (_sizeCheckedElement
        .getComputedStyle()
        .position == 'static') {
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

  void _sizesRecheck() {
    if (_changePending) return;
    _changePending = true;
    new Future.delayed(const Duration(milliseconds: 20)).then((_) {
      _changePending = false;
      width = sizeCheckedElement.offsetWidth;
      height = sizeCheckedElement.offsetHeight;
    });
  }
}
