pragma solidity ^0.4.0;


contract eventh {

    //Create the ticket
    struct Ticket {
        string tName; //Name of the event
        uint8 tNumber; //Asigns a ID number for the ticket
        uint256 tValue; //Value for the ticket
        bool tFree; //Indicates if the events is free or not.
        bool tSold; //Checks if the ticket has been sold
        bool tPunched; //Activated when the assistant go to the event
    }

                         /// ----- VARIABLES ----- ///

    address public organiser; //Identifing the owner a.k. as the organizer
    string public eventName; //Event name, could be changed for an ID
    uint256 public value; //Value per ticket
    bool public eventFree; //Set if the event is free or not
    uint8 public totalTickets; //total number of tickets
    uint8 public issuedTickets; //Tickets sold
    mapping(address => Ticket) assistants; //List of assistants
    //Ticket[] ticketStack;

                        /// ----- MODIFIERS ----- ///

    modifier onlyOrganiser {
        require(msg.sender == organiser);
        _;
    }

                        /// ----- CONTRACT CREATION ----- ///

    constructor (string _eventName, uint256 _value, bool _eventFree, uint8 _totalTickets) public payable {

        //require(msg.value == 1 ether);

        organiser = msg.sender; //The organiser is the one that creates the contract
        eventName = _eventName;
        value = _value;
        eventFree = _eventFree;
        totalTickets = _totalTickets;
        issuedTickets = 0;
    }//constructor


                        /// ----- USER REQUEST TICKET ----- ///

    function takeTicket() payable{

        address assistant = msg.sender;
        require(msg.value == 1 ether); //pay for the ticket

        //Check if the sender already has purchased a ticket. If not issue one
        //We also should avoid the organiser buy a ticket. ?
        if(assistants[assistant].tSold != true) {

            //Issue the ticket if there are tickets left
            if(issuedTickets<totalTickets){
                issuedTickets++;
                Ticket memory ticket = Ticket(eventName,issuedTickets,value,eventFree,true,false);
                assistants[assistant] = ticket;
            }else{
                assistant.transfer(1 ether);
            }//if not inform that there are no tickets left and return ether

        }else{
            assistant.transfer(1 ether);
        }//if not inform the user that already has a ticketand return ether

    }//takeTicket

                    /// ----- ORGANISER CHECKS ATTENDANCE ----- ///

    function isHere(address _assistant) onlyOrganiser {

    }//isHere


}
