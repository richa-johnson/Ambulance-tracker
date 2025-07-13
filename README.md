#  ResqRoute – Real-Time Ambulance Tracker

**ResqRoute** is a real-time ambulance tracking and booking platform developed during our internship at **DITS, Kannur**. It addresses the emergency service gap by connecting patients to the nearest available ambulances — both government and private — based on real-time location and medical needs.

---

##  Problem Statement

The 108 ambulance service in India is primarily limited to government vehicles. In critical situations, patients often struggle to find private ambulances promptly. **ResqRoute** was created to solve this issue by building a platform that unifies all ambulance services, enabling quick access and reliable tracking.

---

##  Features

- **Live Ambulance Availability**: Displays all currently available ambulances.
- **Proximity-Based Sorting**: Uses OpenStreetMap & OSRM to calculate real-time distances.
- **Advanced Filtering**: Filter ambulances by:
  - Facilities (Oxygen, ICU, Ventilator)
  - Vehicle capacity
  - Sector (Government/Private)
- **Multi-Patient Booking**: Users can book for multiple patients in one go.
- **Role-Based Dashboards**:
  - **User**: Search, filter, and book ambulances, and view booking history.
  - **Driver**: Manage incoming bookings and availability status.
  - **Admin**: Add/edit ambulances, monitor system, and manage users.
- **Secure Login System** for all roles.
- **Booking History Tracking**: For both users and drivers.

---

##  Tech Stack

- **Frontend**: Flutter  
- **Backend**: Laravel (PHP)  
- **Database**: MySQL  
- **APIs**: RESTful API integration  
- **Maps & Routing**: OpenStreetMap + OSRM

---

##  GitHub Repository

- [🔗 GitHub Repo](https://github.com/richa-johnson/Ambulance-tracker)

---

##  Developed By

- [Diya Betcy](https://github.com/diyabetcy)  
- [Richa Maria Johnson](https://github.com/richa-johnson)
- [Devatheertha V](https://github.com/devatheertha)

As part of internship at **DITS, Kannur**

---

##  Repository Structure

lib/ # Flutter frontend
routes/ # API routes (Laravel)
app/Http/ # Backend controllers
database/ # Migration
public/ # Public assets and uploads
...

##  Project Status

**Completed**  
 Internship Project – Done at **DITS, Kannur**  
 Year: 2025

---

##  License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

##  Acknowledgements

- DITS Kannur for providing internship opportunity and mentorship  
- OpenStreetMap & OSRM for mapping support
