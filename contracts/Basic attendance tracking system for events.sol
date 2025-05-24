// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BasicAttendanceTracking {
    struct Event {
        string name;
        uint256 date;
        address organizer;
        mapping(address => bool) attendees;
        uint256 attendeeCount;
        bool exists;
    }

    mapping(uint256 => Event) private events;
    uint256 public eventCount;

    event EventCreated(uint256 indexed eventId, string name, uint256 date, address indexed organizer);
    event AttendanceMarked(uint256 indexed eventId, address indexed attendee);

    // Create a new event
    function createEvent(string calldata name, uint256 date) external {
        require(bytes(name).length > 0, "Event name required");
        require(date > block.timestamp, "Event date must be in the future");

        eventCount++;
        Event storage newEvent = events[eventCount];
        newEvent.name = name;
        newEvent.date = date;
        newEvent.organizer = msg.sender;
        newEvent.exists = true;

        emit EventCreated(eventCount, name, date, msg.sender);
    }

    // Mark attendance for an event
    function markAttendance(uint256 eventId) external {
        Event storage ev = events[eventId];
        require(ev.exists, "Event does not exist");
        require(block.timestamp >= ev.date, "Event not started yet");
        require(!ev.attendees[msg.sender], "Attendance already marked");

        ev.attendees[msg.sender] = true;
        ev.attendeeCount++;

        emit AttendanceMarked(eventId, msg.sender);
    }

    // Check if an address attended an event
    function hasAttended(uint256 eventId, address attendee) external view returns (bool) {
        Event storage ev = events[eventId];
        require(ev.exists, "Event does not exist");
        return ev.attendees[attendee];
    }

    // Get basic event info
    function getEvent(uint256 eventId) external view returns (string memory name, uint256 date, address organizer, uint256 attendeeCount) {
        Event storage ev = events[eventId];
        require(ev.exists, "Event does not exist");
        return (ev.name, ev.date, ev.organizer, ev.attendeeCount);
    }
}
