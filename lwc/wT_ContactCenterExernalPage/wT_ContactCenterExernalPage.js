import { LightningElement, wire,track } from 'lwc';
import getUniversalLinks from '@salesforce/apex/WT_ContactCenterLinksHelper.getUniversalLinks';
import getFXDLinks from '@salesforce/apex/WT_ContactCenterLinksHelper.getFXDLinks';
import getVisionContentLinks from '@salesforce/apex/WT_ContactCenterLinksHelper.getVisionContentLinks';
export default class HelloIteration extends LightningElement {    
    
    @wire(getUniversalLinks) universalLinks;
    @wire(getFXDLinks) bankLinks;
    @wire(getVisionContentLinks) bankVCLinks;       
}