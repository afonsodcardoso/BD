CREATE SCHEMA flight_reservations;
GO

CREATE TABLE flight_reservations.airport(
	Airport_code	INT PRIMARY KEY NOT NULL,
	City			VARCHAR(50) NOT NULL,
	State			VARCHAR(50) NOT NULL,
	Name			VARCHAR(50) NOT NULL
);

CREATE TABLE flight_reservations.airplane_type(
	Type_name		VARCHAR(50) PRIMARY KEY NOT NULL,
	Max_seats		INT NOT NULL,
	Company			VARCHAR(50) NOT NULL
);

CREATE TABLE flight_reservations.airplane(
	Airplane_id		INT PRIMARY KEY NOT NULL,
	Total_no_seats	INT NOT NULL,
	Type VARCHAR(50) REFERENCES	flight_reservations.airplane_type(Type_name) NOT NULL
);

CREATE TABLE flight_reservations.flight(
	Number			INT PRIMARY KEY NOT NULL,
	Airline			VARCHAR(50) NOT NULL,
	Weekdays		VARCHAR(50) NOT NULL,
	Type VARCHAR(50) REFERENCES	flight_reservations.airplane_type(Type_name) NOT NULL
);

CREATE TABLE flight_reservations.can_land(
	Airplane_type	VARCHAR(50) REFERENCES	flight_reservations.airplane_type(Type_name) NOT NULL,
	Airport			INT REFERENCES	flight_reservations.airport(Airport_code) NOT NULL
	PRIMARY KEY(Airplane_type, Airport)
	);

CREATE TABLE flight_reservations.fare(
	Flight_fares	INT REFERENCES flight_reservations.flight(Number) NOT NULL,
	Code			INT NOT NULL,
	Amount			INT NOT NULL,
	RESTRICTIONS	VARCHAR(50) NOT NULL,
	PRIMARY KEY(Flight_fares, Code)
);

CREATE TABLE flight_reservations.seat(
	Seat_no				INT NOT NULL,
	Flight_legs			INT NOT NULL,
	Leg_date			DATE,
	Flight_legs_no		INT NOT NULL,
	Customer_name		VARCHAR(50) NOT NULL,
	Cphone				INT NOT NULL,
	PRIMARY KEY(Seat_no, Flight_legs, Leg_date, Flight_legs_no)
);


CREATE TABLE flight_reservations.leg_instance(
	Date				DATE NOT NULL,
	Flight_legs			INT NOT NULL,
	Flight_legs_no		INT NOT NULL,
	No_of_avail_seats	INT NOT NULL,
	Assigned_airplane	INT REFERENCES flight_reservations.airplane(Airplane_id) NOT NULL,
	Dep_airport			INT REFERENCES flight_reservations.airport(Airport_code) NOT NULL,
	Dep_time			DATE,
	Arr_airport			INT REFERENCES flight_reservations.airport(Airport_code) NOT NULL,
	Arr_time			DATE,
	FOREIGN KEY(Date)	REFERENCES flight_reservations.seat(Leg_date),
	PRIMARY KEY(Date, Flight_legs, Flight_legs_no)
);

CREATE TABLE flight_reservations.flight_leg(
	Leg_no				INT PRIMARY KEY NOT NULL,
	Flight_legs			INT NOT NULL,
	Dep_airport			INT REFERENCES flight_reservations.airport(Airport_code) NOT NULL,
	Scheduled_dep_time	DATE,
	Arr_airport			INT REFERENCES flight_reservations.airport(Airport_code) NOT NULL,
	Scheduled_arr_time  DATE,
	FOREIGN KEY(Flight_legs) REFERENCES flight_reservations.leg_instance(Flight_legs)
);