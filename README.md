some more Angular 2 dart components
 
 * Resize sensor
   - component checking for element sizes change inspired by 
   https://github.com/flowkey/resize-sensor
    Example usage:
```dart
@Component(
   selector: 'my-component',
   directives: const[ResizeSensor],
   template: r'''
   <div>
     some content
     <resize-sensor (resize)="$event"></resize-sensor>
   </div>
''')
   class MyComponent{
     void resize(ResizeEvent event){
       print("${event.width} ${event.height}");
     }
   }
```
