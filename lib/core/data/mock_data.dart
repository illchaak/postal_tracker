import '../../models/shipment.dart';
import '../../models/shipment_status.dart';
import '../../models/status_event.dart';
import '../../models/user_profile.dart';

/// Тестові (hardcoded) дані замість реального сервера.
/// Буде замінено на Firebase у наступних лабораторних роботах.
class MockData {
  MockData._();

  static const UserProfile user = UserProfile(
    fullName: 'Інна Люльчак',
    greetingName: 'Інно',
    email: 'inna.l@gmail.com',
    phone: '+380 67 123 45 67',
    language: 'Українська',
    passwordChangedAt: '12.09.2026',
  );

  static const List<String> carriers = ['Нова пошта', 'Укрпошта', 'Meest', 'Інший'];

  static const List<String> languages = ['Українська', 'English'];

  static const List<Shipment> shipments = [
    Shipment(
      id: '1',
      title: 'Навушники Sony WH-1000XM5',
      trackingNumber: '20450987654321',
      carrier: 'Нова пошта',
      isIncoming: true,
      status: ShipmentStatus.inTransit,
      expectedDate: '10.10.2026',
      sender: 'ТОВ «Технокрам», Київ',
      destination: 'Львів, відділення №12',
      sentDate: '08.10.2026',
      cost: '95 грн',
      note: 'Забрати після пар, відділення працює до 20:00.',
      history: [
        StatusEvent(status: ShipmentStatus.inTransit, dateTime: '09.10.2026, 14:20', location: 'Сортувальний центр, Львів'),
        StatusEvent(status: ShipmentStatus.sent, dateTime: '08.10.2026, 18:05', location: 'Київ, відділення №25'),
        StatusEvent(status: ShipmentStatus.created, dateTime: '08.10.2026, 11:32', location: 'Посилку додано до трекера'),
      ],
    ),
    Shipment(
      id: '2',
      title: 'Книги для навчання',
      trackingNumber: '0503812345678',
      carrier: 'Укрпошта',
      isIncoming: true,
      status: ShipmentStatus.atBranch,
      expectedDate: '09.10.2026',
      sender: 'Видавництво «Ранок», Харків',
      destination: 'Львів, відділення 79013',
      sentDate: '05.10.2026',
      cost: '60 грн',
      history: [
        StatusEvent(status: ShipmentStatus.atBranch, dateTime: '09.10.2026, 09:10', location: 'Львів, відділення 79013'),
        StatusEvent(status: ShipmentStatus.sent, dateTime: '05.10.2026, 16:40', location: 'Харків'),
      ],
    ),
    Shipment(
      id: '3',
      title: 'Подарунок для мами',
      trackingNumber: '20450911223344',
      carrier: 'Нова пошта',
      isIncoming: false,
      status: ShipmentStatus.sent,
      expectedDate: '11.10.2026',
      sender: 'Інна Люльчак',
      recipient: 'Люльчак О.',
      destination: 'Тернопіль, відділення №3',
      sentDate: '09.10.2026',
      cost: '80 грн',
      history: [
        StatusEvent(status: ShipmentStatus.sent, dateTime: '09.10.2026, 12:00', location: 'Львів, відділення №12'),
      ],
    ),
    Shipment(
      id: '4',
      title: 'Зимова куртка',
      trackingNumber: 'MEEST-77421905',
      carrier: 'Meest',
      isIncoming: true,
      status: ShipmentStatus.received,
      expectedDate: '05.10.2026',
      destination: 'Львів, поштомат №2214',
      history: [
        StatusEvent(status: ShipmentStatus.received, dateTime: '05.10.2026, 18:30', location: 'Львів, поштомат №2214'),
      ],
    ),
    Shipment(
      id: '5',
      title: 'Чохол для телефона',
      trackingNumber: '20450955667788',
      carrier: 'Нова пошта',
      isIncoming: true,
      status: ShipmentStatus.created,
      expectedDate: '14.10.2026',
      destination: 'Львів, відділення №12',
      history: [
        StatusEvent(status: ShipmentStatus.created, dateTime: '09.10.2026, 10:15', location: 'Посилку додано до трекера'),
      ],
    ),
    Shipment(
      id: '6',
      title: 'Повернення кросівок',
      trackingNumber: '20450933445566',
      carrier: 'Нова пошта',
      isIncoming: false,
      status: ShipmentStatus.returned,
      expectedDate: '03.10.2026',
      sender: 'Інна Люльчак',
      recipient: 'Інтернет-магазин, Київ',
      destination: 'Київ, відділення №1',
      history: [
        StatusEvent(status: ShipmentStatus.returned, dateTime: '03.10.2026, 15:00', location: 'Київ, відділення №1'),
      ],
    ),
    Shipment(
      id: '7',
      title: 'Документи до деканату',
      trackingNumber: '0503899001122',
      carrier: 'Укрпошта',
      isIncoming: false,
      status: ShipmentStatus.received,
      expectedDate: '01.10.2026',
      sender: 'Інна Люльчак',
      recipient: 'Деканат ІКНІ',
      destination: 'Львів, відділення 79000',
      history: [
        StatusEvent(status: ShipmentStatus.received, dateTime: '01.10.2026, 11:20', location: 'Львів, відділення 79000'),
      ],
    ),
  ];

  /// Найближчі очікувані доставки для головного екрана.
  static const List<({String day, String month, String title, String carrier})>
      upcoming = [
    (day: '10', month: 'жовт.', title: 'Навушники Sony WH-1000XM5', carrier: 'Нова пошта'),
    (day: '11', month: 'жовт.', title: 'Подарунок для мами', carrier: 'Нова пошта'),
    (day: '14', month: 'жовт.', title: 'Чохол для телефона', carrier: 'Нова пошта'),
  ];
}
