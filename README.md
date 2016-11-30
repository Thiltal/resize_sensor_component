some more Angular 2 dart components
 
 * Resize sensor
   - component checking for element sizes change inspired by 
   https://github.com/flowkey/resize-sensor
    Example usage:
    
           @Component(
              selector: 'my-component',
              directives: const[ResizeSensor],
              template: '''
              <div #sizeCheckedElement>
                some content
                <resize-sensor [resizeEvent]="resizeEvent"></resize-sensor>
              </div>
           ''')
           class MyComponent implements OnInit {
             HtmlElement _sizeCheckedElement;
             ResizeEvent resizeEvent = new ResizeEvent();
             @ViewChild('sizeCheckedElement')
             set sizeCheckedElement(ElementRef elementRef) {
               _sizeCheckedElement = elementRef.nativeElement;
             }
       
             @override
             void ngOnInit() {
               resizeEvent.sizeCheckedElement = _sizeCheckedElement;
               resizeEvent.onHeightChanged = (){
                 print(resizeEvent.height);
               };
               resizeEvent.onWidthChanged = (){
                 print(resizeEvent.height);
               };
             }
           }